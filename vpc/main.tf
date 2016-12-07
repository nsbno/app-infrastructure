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

resource "aws_internet_gateway" "default_ig" {
    vpc_id = "${aws_vpc.default.id}"
    tags { Name = "${var.ig_name}" }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default_ig.id}"
}

# NAT instance with elastic ip

resource "aws_nat_gateway" "nat" {
  count         = "${var.nat_gateway_enabled}"
  allocation_id = "${var.nat_eip_allocation_id}"
  subnet_id     = "${aws_subnet.public_subnet.0.id}"
  depends_on    = ["aws_internet_gateway.default_ig"]
}

/*
  Public subnets
*/
resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  count                   = 1
  cidr_block              = "${lookup(var.public_subnets_cidr_blocks, "zone_${count.index}")}"
  availability_zone       = "${lookup(var.zones, "zone_${count.index}")}"
  map_public_ip_on_launch = true

  tags { Name = "Public subnet, zone ${count.index}" }
}

resource "aws_route_table" "eu-central-1a-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default_ig.id}"
    }

    tags { Name = "Public subnets route table" }
}

resource "aws_route_table_association" "eu-central-1a-public" {
    subnet_id      = "${aws_subnet.public_subnet.0.id}"
    route_table_id = "${aws_route_table.eu-central-1a-public.id}"
}

/*
  Private subnets
*/
resource "aws_subnet" "private_subnet" {
    vpc_id            = "${aws_vpc.default.id}"
    count             = 2
    cidr_block        = "${lookup(var.private_subnets_cidr_blocks, "zone_${count.index}")}"
    availability_zone = "${lookup(var.zones, "zone_${count.index}")}"

    tags { Name = "Private subnet, zone ${count.index}" }
}


resource "aws_route_table" "eu-central-private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat.id}"
    }

    tags { Name = "Private subnets route table" }
}

resource "aws_route_table_association" "eu-central-1a-private" {
    subnet_id      = "${aws_subnet.private_subnet.0.id}"
    route_table_id = "${aws_route_table.eu-central-private.id}"
}

resource "aws_route_table_association" "eu-central-1b-private" {
    subnet_id      = "${aws_subnet.private_subnet.1.id}"
    route_table_id = "${aws_route_table.eu-central-private.id}"
}

resource "aws_db_subnet_group" "db" {
  depends_on  = ["aws_subnet.private_subnet"]
  name        = "db_subnet_group"
  description = "DB subnet group"
  subnet_ids  = ["${aws_subnet.private_subnet.*.id}"]
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
