resource "aws_iam_role" "role" {
  name               = "${var.role_name}"
  description        = "${var.description}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
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
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
