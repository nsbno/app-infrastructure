resource "aws_dynamodb_table" "dynamodb-table" {
  name             = "${var.env}${var.name}"
  read_capacity    = 1
  write_capacity   = 1
  hash_key         = "${var.hash_key}"
  stream_enabled   = "${var.stream_enabled}"
  stream_view_type = "${var.stream_view_type}"

  ttl {
    enabled        = "${var.ttl_enabled}"
    attribute_name = "${var.ttl_attribute_name}"
  }

  attribute {
    name = "${var.hash_key}"
    type = "S"
  }

  tags {
    Name        = "${var.env}${var.name}"
    Environment = "${var.env}"
  }

  lifecycle {
    ignore_changes = [
      "read_capacity",
      "write_capacity",
      "tags",
    ]
  }

  point_in_time_recovery {
    enabled = "${var.env == "prod" ? true : false}"
  }

  server_side_encryption {
    enabled = "${var.encryption_enabled}"
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  max_capacity       = "${var.read_capacity_max}"
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.dynamodb-table.id}"
  role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  max_capacity       = "${var.write_capacity_max}"
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.dynamodb-table.id}"
  role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_table_read_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_table_write_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_table_write_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}

data "aws_caller_identity" "current" {}
