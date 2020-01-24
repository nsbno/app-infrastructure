resource "aws_dynamodb_table" "dynamodb-table" {
  name             = "${var.env}${var.name}"
  read_capacity    = 1
  write_capacity   = 1
  hash_key         = var.hash_key
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type

  ttl {
    enabled        = var.ttl_enabled
    attribute_name = var.ttl_attribute_name
  }

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.hash_key
      type = attribute.value.type
    }
  }

  tags = {
    Name        = "${var.env}${var.name}"
    Environment = var.env
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
      ttl,
      tags,
    ]
  }

  point_in_time_recovery {
    enabled = var.env == "prod" ? true : false
  }

  server_side_encryption {
    enabled = var.encryption_enabled
  }

  dynamic "global_secondary_index" {
    for_each = var.indices
    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = global_secondary_index.value.name
      read_capacity      = 1
      write_capacity     = 1
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.non_key_attributes
    }
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  max_capacity       = var.read_capacity_max
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.dynamodb-table.id}"
  role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  max_capacity       = var.write_capacity_max
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.dynamodb-table.id}"
  role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target.service_namespace

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
  resource_id        = aws_appautoscaling_target.dynamodb_table_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_target" "dynamodb_index_read_target" {
  count              = length(var.indices)
  max_capacity       = var.read_capacity_max
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.dynamodb-table.id}/index/${element(var.indices, count.index).name}"
  role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_index_read_policy" {
  count              = length(var.indices)
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_index_read_target[count.index].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_index_read_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_index_read_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_index_read_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_target" "dynamodb_index_write_target" {
  count              = length(var.indices)
  max_capacity       = var.write_capacity_max
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.dynamodb-table.id}/index/${element(var.indices, count.index).name}"
  role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_index_write_policy" {
  count              = length(var.indices)
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_index_write_target[count.index].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_index_write_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_index_write_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_index_write_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}

data "aws_caller_identity" "current" {
}

