resource "aws_iam_role" "role" {
  name = "${var.role_name}"

  assume_role_policy = "${var.role_policy}"
}

resource "aws_iam_policy" "policy" {
  name        = "${var.policy_name}"
  description = "${var.description}"
  policy      = "${var.policy_template}"
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_role_policy_attachment" "default-policy-attach" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
