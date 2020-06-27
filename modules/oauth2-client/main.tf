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
  explicit_auth_flows                  = []

  allowed_oauth_flows  = ["client_credentials"]
  allowed_oauth_scopes = var.oauth_scopes
}

resource "aws_secretsmanager_secret" "client_credentials" {
  count       = local.should_add_secret_to_secrets_manager
  name        = "${var.env}/${var.appname}/oauth2/client_credentials"
  description = "Client credentials for ${var.appname} to access the microservices"

  tags = {
    environment = var.env
    appname     = var.appname
  }
}

resource "aws_secretsmanager_secret_version" "client_credentials_value" {
  count     = local.should_add_secret_to_secrets_manager
  secret_id = aws_secretsmanager_secret.client_credentials[0].id

  secret_string = jsonencode({
    "oauth2.clientId"         = aws_cognito_user_pool_client.client.id,
    "oauth2.clientSecret"     = aws_cognito_user_pool_client.client.client_secret,
    "oauth2.tokenEndpointUrl" = "https://${data.aws_cognito_user_pools.user_pool.name}.auth.eu-central-1.amazoncognito.com/oauth2/token"
  })
}

data "aws_iam_policy_document" "secret_policy_document" {
  count = local.should_add_secret_to_secrets_manager
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = ["${substr(aws_secretsmanager_secret.client_credentials[0].arn, 0, length(aws_secretsmanager_secret.client_credentials[0].arn) - 7)}-??????"]
  }

  statement {
    actions = [
      "secretsmanager:ListSecrets"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  count       = local.should_add_policy_to_role
  name        = "${var.env}-${var.appname}-oauth2-credentials-policy"
  path        = "/"
  description = "Allow ${var.env}-${var.appname} to get Oauth2 credentials from Secrets Manager"
  policy      = data.aws_iam_policy_document.secret_policy_document[0].json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = local.should_add_policy_to_role
  role       = var.role_name
  policy_arn = aws_iam_policy.policy[0].arn
}

locals {
  should_add_policy_to_role            = (var.role_name != "" ? 1 : 0) * (var.store_credentials ? 1 : 0)
  should_add_secret_to_secrets_manager = var.store_credentials ? 1 : 0
}
