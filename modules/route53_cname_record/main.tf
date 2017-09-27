data "aws_route53_zone" "route53_zone" {
  name = "${var.route53_zone}"
}

resource "aws_route53_record" "environment_route53_record" {
  zone_id = "${data.aws_route53_zone.route53_zone.zone_id}"
  name    = "${var.route53_record_name}"
  type    = "CNAME"
  ttl     = "${var.route53_record_ttl}"
  records = ["${var.route53_record}"]
}
