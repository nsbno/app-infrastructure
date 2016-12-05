/*
  ELB security group
*/

resource "aws_security_group" "load_balancer" {
    vpc_id      = "${var.vpc_id}"
    name        = "${var.elb_sg}"
    description = "Allow incoming HTTP(S) connections from everywhere and connect to appservers"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = ["${var.appserver_security_group_id}"]
    }
}
