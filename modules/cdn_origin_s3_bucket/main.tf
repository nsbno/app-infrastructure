resource "aws_s3_bucket" "cdn_origin_s3_bucket" {
  bucket = "${var.bucket_name}"
  policy = "${data.aws_iam_policy_document.cdn_access_s3_content_policy.json}"
}

data "aws_iam_policy_document" "cdn_access_s3_content_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]

    principals {
      identifiers = ["${var.origin_access_id_arn}"]
      type        = "AWS"
    }
  }
}
