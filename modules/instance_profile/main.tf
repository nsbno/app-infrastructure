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

resource "aws_iam_role_policy_attachment" "instance_profile_eb_web_tier_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
  role = "${aws_iam_role.instance_profile_role.name}"
}

resource "aws_iam_role_policy_attachment" "instance_profile_cw_logs_full_access_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role = "${aws_iam_role.instance_profile_role.name}"
}

resource "aws_iam_role_policy_attachment" "instance_profile_additional_policy_attachment" {
  policy_arn = "${aws_iam_policy.instance_profile_additional_policy.arn}"
  role = "${aws_iam_role.instance_profile_role.name}"
}

resource "aws_iam_policy" "instance_profile_additional_policy" {
  name = "${var.additional_policy_name}"
  description = "${var.additional_policy_description}"
  policy = "${var.additional_policy}"
}

