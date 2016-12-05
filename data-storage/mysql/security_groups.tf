/*
  DB security group
*/

resource "aws_security_group" "db" {
    vpc_id      = "${var.vpc_id}"
    name        = "${var.db_sg_name}"
    description = "Allow incoming database connections."

    ingress { # MySQL
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = ["${var.appserver_security_group_id}"]
    }
}
