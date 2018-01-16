output "bucket_arn" {
  value = "${aws_s3_bucket.private_bucket.arn}"
}

output "name" {
  value = "${aws_s3_bucket.private_bucket.id}"
}
