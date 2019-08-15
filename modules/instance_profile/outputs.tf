output "name" {
  value = "${aws_iam_instance_profile.instance_profile.name}"
}

output "arn" {
  value = "${aws_iam_instance_profile.instance_profile.arn}"
}
