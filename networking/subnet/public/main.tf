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

