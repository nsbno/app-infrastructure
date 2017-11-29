provider "aws" {
  region = "us-east-1"
}

data "aws_acm_certificate" "certificate" {
  domain   = "${var.appname}.${var.domain}"
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = "${var.origin_id}"
    origin_id   = "S3-${var.env}.${var.appname}.${var.domain}"
  }
  enabled      = true
  aliases      = [ "${var.env}.${var.appname}.${var.domain}" ]
  price_class  = "PriceClass_100"
  default_cache_behavior {
    allowed_methods  = [ "GET", "HEAD" ]
    cached_methods   = [ "GET", "HEAD" ]
    target_origin_id = "S3-${var.env}.${var.appname}.${var.domain}"
    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  retain_on_delete = "false"
  viewer_certificate {
     iam_certificate_id       = true
     acm_certificate_arn      = "${data.aws_acm_certificate.certificate.arn}"
     ssl_support_method       = "sni-only"
     minimum_protocol_version = "TLSv1"
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "EU"]
    }
  }
}

