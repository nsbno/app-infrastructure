resource "aws_s3_bucket_object" "object" {
  bucket       = "${var.bucket_name}"
  key          = "${var.bucket_key}"
  source       = "${var.bucket_file}"
  etag         = "${md5(file("${var.bucket_file}"))}"
  content_type = "${var.content_type}"
}
