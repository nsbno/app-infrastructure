/*
  DB security group
*/

resource "aws_security_group" "db" {
    vpc_id      = "${var.vpc_id}"
    name        = "${var.db_sg_name}"
    description = "${var.db_sg_name}"
}
