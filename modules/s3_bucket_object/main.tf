resource "aws_s3_bucket_object" "object" {
  bucket       = var.bucket_name
  key          = var.bucket_key
  source       = var.bucket_file
  etag         = filemd5(var.bucket_file)
  content_type = var.content_type
}

