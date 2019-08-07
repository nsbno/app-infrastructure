resource "aws_api_gateway_rest_api" "api" {
  name = "${var.vpc_name}-${var.name}"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "${var.resource_path_part}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.resource.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "200"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on        = ["aws_api_gateway_integration.integration",
                       "aws_api_gateway_method.method"]
  rest_api_id       = "${aws_api_gateway_rest_api.api.id}"
  stage_name        = "${var.vpc_name}"
  stage_description = "Lambda: ${var.name} (sha: ${var.lambda_sha})"
  description       = "Lambda arn: ${var.lambda_arn}"
  lifecycle {
    create_before_destroy = true
  }
}

provider "aws" {
  region = "us-east-1"
  alias = "use1"
}

data "aws_acm_certificate" "certificate" {
  provider = "aws.use1"
  domain   = "${var.certificate_domain}"
  statuses = ["ISSUED"]
}

resource "aws_api_gateway_domain_name" "domain" {
  domain_name = "${var.domain}"
  certificate_arn = "${data.aws_acm_certificate.certificate.arn}"
}

resource "aws_api_gateway_base_path_mapping" "base_path_mapping" {
  api_id      = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${aws_api_gateway_deployment.deployment.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.domain.domain_name}"
}

data "aws_route53_zone" "route53_zone" {
  name   = "${var.zone_domain}"
}

resource "aws_route53_record" "route53_record" {
  zone_id = "${data.aws_route53_zone.route53_zone.id}" # See aws_route53_zone for how to create this

  name = "${aws_api_gateway_domain_name.domain.domain_name}"
  type = "A"
  alias {
    name                   = "${aws_api_gateway_domain_name.domain.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.domain.cloudfront_zone_id}"
    evaluate_target_health = true
  }
}
