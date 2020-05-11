data "aws_cognito_user_pools" "user_pool" {
  name = "${var.vpc_name}-microservice-clients"
}

resource "aws_cognito_user_pool_client" "client" {
  name                          = "${var.env}-${var.appname}"
  user_pool_id                  = sort(data.aws_cognito_user_pools.user_pool.ids)[0]
  generate_secret               = true
  prevent_user_existence_errors = "ENABLED"

  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  explicit_auth_flows                  = ["ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]

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
    "oauth2.clientId"         = aws_cognito_user_pool_client.client.id,
    "oauth2.clientSecret"     = aws_cognito_user_pool_client.client.client_secret,
    "oauth2.tokenEndpointUrl" = "https://${data.aws_cognito_user_pools.user_pool.name}.auth.eu-central-1.amazoncognito.com/oauth2/token"
  })
}

data "aws_iam_policy_document" "secret_policy_document" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [aws_secretsmanager_secret.client_credentials.arn]
  }

  statement {
    actions = [
      "secretsmanager:ListSecrets"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  name        = "${var.env}-${var.appname}-oauth2-credentials-policy"
  path        = "/"
  description = "Allow ${var.env}-${var.appname} to get Oauth2 credentials from Secrets Manager"
  policy      = data.aws_iam_policy_document.secret_policy_document.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = var.instance_profile_name
  policy_arn = aws_iam_policy.policy.arn
}
