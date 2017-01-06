resource "aws_db_instance" "db" {
  name                   = "${var.db_name}"
  identifier             = "${var.db_identifier}"
  allocated_storage      = "${var.db_storage}"
  engine                 = "${var.db_engine}"
  engine_version         = "${var.db_engine_version}"
  instance_class         = "${var.db_instance_class}"
  username               = "${var.db_username}"
  password               = "${var.db_password}"
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
  db_subnet_group_name   = "${var.db_subnet_group_id}"
  parameter_group_name   = "${var.db_parameter_group_name}"
  apply_immediately      = "true"
}

resource "aws_security_group" "db_sg" {
    vpc_id      = "${var.vpc_id}"
    name        = "${var.db_sg_name}"
    description = "${var.db_sg_name}"
}

