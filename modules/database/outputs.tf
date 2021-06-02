output "address" {
  value = aws_route53_record.db_internal_route53_record.fqdn
}

output "port" {
  value = aws_db_instance.db.port
}

output "ssm_username_arn" {
  value = aws_ssm_parameter.rds_username.arn
}

output "ssm_password_arn" {
  value = aws_ssm_parameter.rds_password.arn
}
