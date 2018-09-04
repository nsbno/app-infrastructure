locals {
  default_origin_access_ids = {
    test = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E25B7K2W0FMIPX"
  }
}

resource "aws_s3_bucket" "cdn_origin_s3_bucket" {
  bucket = "${var.bucket_name}"
  policy = "${data.aws_iam_policy_document.cdn_access_s3_content_policy.json}"
}

data "aws_iam_policy_document" "cdn_access_s3_content_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]

    principals {
      identifiers = ["${lookup(local.default_origin_access_ids, var.origin_access_id_env)}"]
      type        = "AWS"
    }
  }
}
