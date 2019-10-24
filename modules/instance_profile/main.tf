resource "aws_iam_instance_profile" "instance_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.instance_profile_role.name
}

resource "aws_iam_role" "instance_profile_role" {
  name        = var.instance_profile_name
  description = var.role_description

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

resource "aws_iam_policy" "cloudwatch_metric_policy" {
  name        = "${var.instance_profile_name}-cloudwatch-metric-policy"
  description = "Provides write access to Cloudwatch metrics"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "cloudwatch:PutMetricData",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "webtier_policy_attachment" {
  role       = aws_iam_instance_profile.instance_profile.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_metric_policy_attachment" {
  role       = aws_iam_instance_profile.instance_profile.name
  policy_arn = aws_iam_policy.cloudwatch_metric_policy.arn
}

