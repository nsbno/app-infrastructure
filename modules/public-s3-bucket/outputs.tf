output "bucket_name" {
  value = aws_s3_bucket.public_bucket.bucket_domain_name
}

