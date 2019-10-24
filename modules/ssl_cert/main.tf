data "aws_acm_certificate" "ssl_cert" {
  domain   = var.domain
  statuses = ["ISSUED"]
}

