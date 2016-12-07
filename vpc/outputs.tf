output "key_pair_id" {
  value = "${aws_key_pair.auth.id}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "icmp_security_group_id" {
  value = "${aws_security_group.icmp.id}"
}

output "allow_outgoing_traffic_security_group_id" {
  value = "${aws_security_group.allow_outgoing_traffic.id}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.default.id}"
}

