/*
  ELB security group
*/

resource "aws_security_group" "load_balancer" {
    vpc_id      = "${var.vpc_id}"
    name        = "${var.elb_sg}"
    description = "Allow incoming HTTP(S) connections from everywhere and connect to appservers"
    tags { Name = "${var.elb_sg}" }
}

resource "aws_security_group_rule" "elb_ingress_http_security_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.load_balancer.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elb_ingress_https_security_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.load_balancer.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
