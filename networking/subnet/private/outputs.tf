output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}

output "db_subnet_group_id" {
  value = "${aws_db_subnet_group.db.id}"
}
