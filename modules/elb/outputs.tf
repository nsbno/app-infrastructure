output "elb_security_group_id" {
  value = "${aws_security_group.load_balancer.id}"
}

output "elb_zone_id" {
  value = "${aws_elb.app.zone_id}"
}

output "elb_dns_name" {
  value = "${aws_elb.app.dns_name}"
}
