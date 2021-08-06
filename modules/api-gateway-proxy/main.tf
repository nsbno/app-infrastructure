data "aws_api_gateway_rest_api" "microservices_api" {
  name = "${var.env}-microservices-api"
}

data "aws_api_gateway_resource" "services_resource" {
  rest_api_id = data.aws_api_gateway_rest_api.microservices_api.id
  path        = "/services"
}

resource "aws_api_gateway_resource" "microservice_resource" {
  rest_api_id = data.aws_api_gateway_rest_api.microservices_api.id
  parent_id   = data.aws_api_gateway_resource.services_resource.id
  path_part   = var.appname
}

resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = data.aws_api_gateway_rest_api.microservices_api.id
  parent_id   = aws_api_gateway_resource.microservice_resource.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = data.aws_api_gateway_rest_api.microservices_api.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
    "method.request.header.X-Vy-Proxied-By-CF" = true
  }
}

resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id             = data.aws_api_gateway_rest_api.microservices_api.id
  resource_id             = aws_api_gateway_resource.proxy_resource.id
  http_method             = aws_api_gateway_method.proxy_method.http_method
  type                    = "HTTP_PROXY"
  uri                     = "${var.destination_uri}/{proxy}"
  integration_http_method = "ANY"

  cache_key_parameters = ["method.request.path.proxy"]

  timeout_milliseconds = 29000
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
    "integration.request.header.X-Vy-Proxied-By-CF" = "method.request.header.X-Vy-Proxied-By-CF"
  }
}

resource "aws_api_gateway_deployment" "prod_deployment" {
  depends_on  = [aws_api_gateway_integration.proxy_integration]
  rest_api_id = data.aws_api_gateway_rest_api.microservices_api.id
  stage_name  = var.stage_name

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.proxy_integration)
    )))
  }

  lifecycle {
    create_before_destroy = true
  }
}
