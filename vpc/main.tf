provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${var.public_key}"
}

resource "aws_vpc" "default" {
    cidr_block           = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    depends_on           = ["aws_key_pair.auth"]
    tags { Name = "${var.vpc_name}" }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
    tags { Name = "${var.ig_name}" }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

/*
  General security groups
*/
resource "aws_security_group" "icmp" {
    vpc_id      = "${aws_vpc.default.id}"
    name        = "ping"
    description = "Allow incoming icmp from anywhere"

    ingress {
        from_port   = 8
        to_port     = 0
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "allow_outgoing_traffic" {
    vpc_id      = "${aws_vpc.default.id}"
    name        = "allow_outgoing_traffic"
    description = "Allow all outgoing traffic"

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
