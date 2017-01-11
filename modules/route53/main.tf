resource "aws_route53_zone" "route53_zone" {
  name = "${var.domain}"
}

resource "aws_route53_record" "environment_route53_record" {
  zone_id        = "${aws_route53_zone.route53_zone.zone_id}"
  name           = "${var.aws_route53_record_name}"
  type           = "CNAME"
  ttl            = "5"
  records        = ["${var.appname}-${var.env}.${var.aws_region}.elasticbeanstalk.com"]
}
