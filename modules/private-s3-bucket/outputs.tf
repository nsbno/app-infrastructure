output "bucket_arn" {
  value = "${aws_s3_bucket.private_bucket.arn}"
}

output "name" {
  value = "${aws_s3_bucket.private_bucket.id}"
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.private_bucket.bucket_domain_name}"
}