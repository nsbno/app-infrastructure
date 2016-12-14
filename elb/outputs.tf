output "elb_security_group_id" {
    value = "${aws_security_group.load_balancer.id}"
}
