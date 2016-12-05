output "key_pair_id" {
  value = "${aws_key_pair.auth.id}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnet.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}

output "icmp_security_group_id" {
  value = "${aws_security_group.icmp.id}"
}

output "allow_outgoing_traffic_security_group_id" {
  value = "${aws_security_group.allow_outgoing_traffic.id}"
}

output "db_subnet_group_id" {
  value = "${aws_db_subnet_group.db.id}"
}