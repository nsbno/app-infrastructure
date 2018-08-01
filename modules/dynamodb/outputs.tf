output "arn" {
  value = "${aws_dynamodb_table.dynamodb-table.arn}"
}

output "name" {
  value = "${aws_dynamodb_table.dynamodb-table.name}"
}
