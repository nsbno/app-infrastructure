output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}

output "private_route_table_id" {
  value = "${aws_route_table.private-route-table.id}"
}
