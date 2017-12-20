resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "${var.env}UserDataRequests"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  stream_enabled = true

  attribute {
    name = "UserId"
    type = "S"
  }

  tags {
    Name        = "dynamodb-table-user-data-requests"
    Environment = "${var.env}"
  }
}
