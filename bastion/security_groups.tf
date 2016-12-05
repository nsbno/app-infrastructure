/*
  Bastion security groups
*/

resource "aws_security_group" "bastion" {
    vpc_id      = "${var.vpc_id}"
    name        = "allow_access_to_bastion"
    description = "Bastion allow SSH on port 22"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # Remember to restrict to ops ip's
    }
}

resource "aws_security_group" "allow_bastion_access" {
    vpc_id      = "${var.vpc_id}"
    name        = "allow_bastion_access"
    description = "Allow SSH on port 22 from bastion host"

    # SSH from bastion
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = ["${aws_security_group.bastion.id}"]
    }
}