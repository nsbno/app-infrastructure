/*
  Public subnets
*/
resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${var.vpc_id}"
  count                   = "${var.number_of_public_subnets}"
  cidr_block              = "${lookup(var.public_subnets_cidr_blocks, "zone_${count.index}")}"
  availability_zone       = "${lookup(var.zones, "zone_${count.index}")}"
  map_public_ip_on_launch = true

  tags { Name = "Public subnet, zone ${count.index}" }
}

resource "aws_route_table" "eu-central-1a-public" {
    vpc_id = "${var.vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${var.internet_gateway_id}"
    }

    tags { Name = "Public subnets route table" }
}

resource "aws_route_table_association" "eu-central-1a-public" {
    subnet_id      = "${aws_subnet.public_subnet.0.id}"
    route_table_id = "${aws_route_table.eu-central-1a-public.id}"
}
