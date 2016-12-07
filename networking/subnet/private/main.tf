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

resource "aws_route_table" "eu-central-private" {
    vpc_id      = "${var.vpc_id}"

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = "${var.nat_id}"
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
