/*
  App security groups
*/

resource "aws_security_group" "appserver" {
    vpc_id      = "${var.vpc_id}"
    name        = "${var.appserver_security_group}"
    description = "Appserver security group"
}

resource "aws_security_group" "appserver_internal_communication" {
    vpc_id      = "${var.vpc_id}"
    name        = "appserver_internal_communication"
    description = "Appservers internal communication"

    # Load balancer
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = ["${var.load_balancer_security_group_id}"]
    }

    # MySQL
    egress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = ["${var.db_security_group_id}"]
    }
}
