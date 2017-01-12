resource "aws_route53_record" "environment_route53_record" {
  zone_id        = "${var.route53_hosted_zone_id}"
  name           = "${var.route53_record_name}"
  type           = "CNAME"
  ttl            = "${var.route53_record_ttl}"
  records        = ["${var.appname}-${var.env}.${var.aws_region}.elasticbeanstalk.com"]
}
