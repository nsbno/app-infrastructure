resource "random_string" "rds_username" {
  count   = var.db_username != "" ? 0 : 1
  length  = 10
  special = false
  numeric = false
}

resource "random_string" "rds_password" {
  length  = 30
  special = false
}

resource "aws_ssm_parameter" "rds_username" {
  name   = "/${var.db_identifier}/rds_username"
  type   = "SecureString"
  value  = var.db_username != "" ? var.db_username : random_string.rds_username[0].result
  key_id = var.kms_key_id
}

resource "aws_ssm_parameter" "rds_password" {
  name   = "/${var.db_identifier}/rds_password"
  type   = "SecureString"
  value  = random_string.rds_password.result
  key_id = var.kms_key_id
}

resource "aws_db_instance" "db" {
  db_name                   = var.db_name
  identifier                = var.db_identifier
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  instance_class            = var.db_instance_class
  username                  = aws_ssm_parameter.rds_username.value
  password                  = aws_ssm_parameter.rds_password.value
  vpc_security_group_ids    = var.vpc_security_group_ids
  db_subnet_group_name      = var.db_subnet_group_name
  parameter_group_name      = var.db_parameter_group_name
  backup_retention_period   = var.backup_retention_period
  availability_zone         = var.availability_zone
  multi_az                  = var.multi_az
  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window
  allocated_storage         = var.allocated_storage
  storage_type              = var.storage_type
  apply_immediately         = var.apply_immediately
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "${var.db_identifier}-final-snapshot"
  license_model             = var.license_model
  deletion_protection       = var.deletion_protection
  monitoring_interval       = var.monitoring_interval

  tags = {
    Name           = var.db_name
    CopyDBSnapshot = var.backup_to_other_account ? "True" : "False"
  }
}

resource "aws_route53_record" "db_internal_route53_record" {
  zone_id = var.db_route53_hosted_zone_id
  name    = "${var.db_identifier}.${var.db_route53_hosted_zone_name}"
  type    = "CNAME"
  ttl     = 5
  records = [aws_db_instance.db.address]
}

