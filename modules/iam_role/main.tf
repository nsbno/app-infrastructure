resource "aws_iam_role" "role" {
  name               = "${var.role_name}"
  assume_role_policy = "${var.role_policy}"
  description        = "${var.description}"
}

