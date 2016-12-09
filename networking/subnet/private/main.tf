/*
  Private subnets
*/
resource "aws_subnet" "private_subnet" {
    vpc_id            = "${var.vpc_id}"
    count             = "${var.number_of_private_subnets}"
    cidr_block        = "${lookup(var.private_subnets_cidr_blocks, "zone_${count.index}")}"
    availability_zone = "${lookup(var.zones, "zone_${count.index}")}"

    tags { Name = "Private subnet, zone ${count.index}" }
}

