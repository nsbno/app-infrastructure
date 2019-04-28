resource "aws_s3_bucket" "cdn_origin_s3_bucket" {
  bucket = "${var.bucket_name}"
  policy = "${data.aws_iam_policy_document.cdn_access_s3_content_policy.json}"

  cors_rule {
    allowed_methods = ["${var.allowed_methods}"]
    allowed_origins = ["${var.allowed_origins}"]
  }

  lifecycle {
    ignore_changes = ["tags"]
  }
}

data "aws_iam_policy_document" "cdn_access_s3_content_policy" {
  statement {
    sid       = "1"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*", "arn:aws:s3:::${var.bucket_name}"]

    principals {
      identifiers = ["${var.origin_access_id_arn == "" ? "*" : "${var.origin_access_id_arn}"}"]
      type        = "${var.origin_access_id_arn == "" ? "*" : "AWS"}"
    }
  }
}
