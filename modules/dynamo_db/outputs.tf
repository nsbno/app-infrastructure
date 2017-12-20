output "arn" {
  value = "${aws_dynamodb_table.dynamodb-table.arn}"
}

output "stream_arn" {
  value = "${aws_dynamodb_table.dynamodb-table.stream_arn}"
}
