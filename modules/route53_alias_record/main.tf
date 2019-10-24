data "aws_route53_zone" "route53_zone" {
  name = var.route53_zone
}

resource "aws_route53_record" "environment_route53_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = var.route53_record_name
  type    = "A"
  alias {
    name                   = var.route53_record
    zone_id                = var.elastic_beanstalk_zone_id
    evaluate_target_health = true
  }
}

