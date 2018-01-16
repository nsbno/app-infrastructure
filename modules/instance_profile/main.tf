resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.instance_profile_name}"
  role = "${aws_iam_role.instance_profile_role.name}"
}

resource "aws_iam_role" "instance_profile_role" {
  name = "${var.role_name}"
  description = "${var.role_description}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

