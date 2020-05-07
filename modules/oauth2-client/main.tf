data "aws_cognito_user_pools" "user_pool" {
  name = "${var.vpc_name}-microservice-clients"
}

resource "aws_cognito_user_pool_client" "client" {
  name                          = "${var.env}-${var.appname}"
  user_pool_id                  = sort(data.aws_cognito_user_pools.user_pool.ids)[0]
  generate_secret               = true
  prevent_user_existence_errors = "ENABLED"

  allowed_oauth_flows  = ["client_credentials"]
  allowed_oauth_scopes = var.oauth_scopes
}

resource "aws_secretsmanager_secret" "client_credentials" {
  name        = "${var.env}/${var.appname}/oauth2/client_credentials"
  description = "Client credentials for ${var.appname} to access the microservices"

  tags = {
    environment = var.env
    appname     = var.appname
  }
}

resource "aws_secretsmanager_secret_version" "client_credentials_value" {
  secret_id = aws_secretsmanager_secret.client_credentials.id

  secret_string = jsonencode({
    "oauth2.client_id"        = aws_cognito_user_pool_client.client.id,
    "oauth2.client_secret"    = aws_cognito_user_pool_client.client.client_secret,
    "oauth2.tokenEndpointUrl" = "https://${data.aws_cognito_user_pools.user_pool.name}.auth.eu-central-1.amazoncognito.com/oauth2/token"
  })
}
