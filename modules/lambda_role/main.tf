locals {
  service_identifiers = {
    basic = ["lambda.amazonaws.com"]
    vpc   = ["lambda.amazonaws.com"]
    cdn   = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
  }
  default_policies = {
    basic = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    vpc   = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
    cdn   = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }
}

data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = "${local.service_identifiers[var.type]}"
    }
  }
}


resource "aws_iam_role" "role" {
  name               = "${var.role_name}"
  description        = "${var.description}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda-assume-role-policy.json}"
}



resource "aws_iam_policy" "policy" {
  count       = "${length(var.policy_templates)}"
  name        = "${element(var.policy_names, count.index)}"
  description = "${element(var.policy_descriptions, count.index)}"
  policy      = "${element(var.policy_templates, count.index)}"
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  count      = "${length(var.policy_templates)}"
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${element(aws_iam_policy.policy.*.arn, count.index)}"
}

resource "aws_iam_role_policy_attachment" "default-policy-attach" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${lookup(local.default_policies, var.type)}"
}
