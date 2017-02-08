resource "aws_route53_record" "environment_route53_record" {
  zone_id = "${var.route53_hosted_zone_id}"
  name    = "${var.route53_record_name}"
  type    = "A"
  alias {
    name = "${var.route53_record}"
    zone_id = "${var.elastic_beanstalk_zone_id}"
    evaluate_target_health = true
  }
}
