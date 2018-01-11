resource "aws_s3_bucket" "private_bucket" {
  bucket = "${var.bucket_name}"
  policy = "${var.policy}"
}
