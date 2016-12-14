resource "aws_db_instance" "db" {
  name                   = "${var.db_name}"
  identifier             = "${var.db_identifier}"
  allocated_storage      = "${var.db_storage}"
  engine                 = "${var.db_engine}"
  engine_version         = "${var.db_engine_version}"
  instance_class         = "${var.db_instance_class}"
  username               = "${var.db_username}"
  password               = "${var.db_password}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  db_subnet_group_name   = "${var.db_subnet_group_id}"
  parameter_group_name   = "${var.db_parameter_group_name}"
  apply_immediately      = "true"
}

