resource "aws_cognito_user_pool_client" "client" {
  name                          = var.appname
  user_pool_id                  = var.user_pool_id
  generate_secret               = true
  prevent_user_existence_errors = "ENABLED"

  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  explicit_auth_flows                  = []

  allowed_oauth_flows  = ["client_credentials"]
  allowed_oauth_scopes = var.oauth_scopes
}

resource "aws_ssm_parameter" "client_id" {
  name  = "/${var.name_prefix}/${var.appname}/oauth2/client-id"
  type  = "SecureString"
  value = aws_cognito_user_pool_client.client.id
  tags  = var.tags
}

resource "aws_ssm_parameter" "client_secret" {
  name  = "/${var.name_prefix}/${var.appname}/oauth2/client-secret"
  type  = "SecureString"
  value = aws_cognito_user_pool_client.client.client_secret
  tags  = var.tags
}


resource "aws_iam_policy" "policy" {
  count       = local.should_add_policy_to_role
  name        = "${var.appname}-oauth2-credentials-policy"
  path        = "/"
  description = "Allow ${var.appname} to get OAuth2 credentials from Parameter Store"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameters",
        ]
        Effect = "Allow"
        Resource = [
          aws_ssm_parameter.client_id.arn,
          aws_ssm_parameter.client_secret.arn,
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = local.should_add_policy_to_role
  role       = var.role_name
  policy_arn = aws_iam_policy.policy[0].arn
}

locals {
  should_add_policy_to_role            = (var.role_name != "" ? 1 : 0) * (var.store_credentials ? 1 : 0)
  should_add_secret_to_parameter_store = var.store_credentials ? 1 : 0
}
