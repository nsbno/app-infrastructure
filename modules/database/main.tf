data "aws_vpc" "vpc" {
  tags { Name = "${var.vpc_name}_vpc" }
}
resource "aws_db_instance" "db" {
  name                      = "${var.db_name}"
  identifier                = "${var.db_identifier}"
  engine                    = "${var.db_engine}"
  engine_version            = "${var.db_engine_version}"
  instance_class            = "${var.db_instance_class}"
  username                  = "${var.db_username}"
  password                  = "${var.db_password}"
  vpc_security_group_ids    = ["${aws_security_group.db_sg.id}"]
  db_subnet_group_name      = "${var.db_subnet_group_id}"
  parameter_group_name      = "${var.db_parameter_group_name}"
  backup_retention_period   = "${var.backup_retention_period}"
  availability_zone         = "${var.availability_zone}"
  multi_az                  = "${var.multi_az}"
  backup_window             = "${var.backup_window}"
  maintenance_window        = "${var.maintenance_window}"
  allocated_storage         = "${var.allocated_storage}"
  storage_type              = "${var.storage_type}"
  apply_immediately         = "${var.apply_immediately}"
  skip_final_snapshot       = "${var.skip_final_snapshot}"
  final_snapshot_identifier = "${var.db_identifier}-final-snapshot"
  license_model             = "${var.license_model}"
}

resource "aws_security_group" "db_sg" {
    vpc_id      = "${data.aws_vpc.vpc.id}"
    name        = "${var.db_sg_name}"
    description = "${var.db_sg_name}"
    tags { Name = "${var.db_sg_name}" }
}

