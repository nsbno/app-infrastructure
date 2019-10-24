data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.vpc_name}_vpc"
  }
}

data "aws_subnet" "private_1a" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}_private_subnet_eu-central-1a"
  }
}

data "aws_subnet" "private_1b" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}_private_subnet_eu-central-1b"
  }
}

data "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
}

resource "aws_lambda_function" "lambda" {
  filename         = var.filename
  function_name    = var.function_name
  description      = var.description
  role             = data.aws_iam_role.iam_for_lambda.arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = filebase64sha256(var.filename)
  publish          = var.publish
  environment {
    variables = var.environment
  }
  vpc_config {
    subnet_ids         = [data.aws_subnet.private_1a.id, data.aws_subnet.private_1b.id]
    security_group_ids = var.security_group_ids
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.lambda.function_name
  principal      = "events.amazonaws.com"
  source_account = var.account_id
  qualifier      = aws_lambda_alias.lambda_alias.name
}

resource "aws_lambda_alias" "lambda_alias" {
  name             = "${var.vpc_name}alias"
  description      = "Alias for ${var.function_name} lambda (${var.vpc_name})"
  function_name    = aws_lambda_function.lambda.function_name
  function_version = "$LATEST"
}

