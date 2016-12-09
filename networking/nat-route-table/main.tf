resource "aws_route_table" "nat_route_table" {
    vpc_id      = "${var.vpc_id}"

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = "${var.nat_id}"
    }

    tags { Name = "${var.env}: route table associated with nat gateway" }
}
