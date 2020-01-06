data "aws_secretsmanager_secret" "secrets" {
  for_each = toset(var.secret_ids)
  name     = each.value
}

data "aws_iam_policy_document" "secret_policy_document" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [for k, v in data.aws_secretsmanager_secret.secrets : "${substr(v.arn, 0, length(v.arn) - 7)}-??????"]
  }

  statement {
    actions = [
      "secretsmanager:ListSecrets"
    ]

    resources = ["*"]
  }
}

module "get-secret-policy" {
  source             = "git@github.com:nsbno/app-infrastructure.git//modules/iam_policy?ref=c378895"
  policy             = data.aws_iam_policy_document.secret_policy_document.json
  policy_name        = "${var.env}-${var.appname}-get-secret-policy"
  policy_description = "Allow getting secret from Secrets Manager"
}

module "get-secret-policy-attachment" {
  source     = "git@github.com:nsbno/app-infrastructure.git//modules/policy_attachment?ref=c378895"
  role       = var.role_name
  policy_arn = module.get-secret-policy.arn
}

