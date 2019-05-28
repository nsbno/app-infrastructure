output "bucket_domain_name" {
  value = "${aws_s3_bucket.cdn_origin_s3_bucket.bucket_domain_name}"
}
