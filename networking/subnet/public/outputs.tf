output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnet.*.id}"]
}

output "public_route_table_id" {
  value = "${aws_route_table.public-route-table.id}"
}
