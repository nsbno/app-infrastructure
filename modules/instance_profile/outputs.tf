output "name" {
  value = aws_iam_instance_profile.instance_profile.name
}

output "arn" {
  value = aws_iam_instance_profile.instance_profile.arn
}

output "role_arn" {
  value = aws_iam_role.instance_profile_role.arn
}

