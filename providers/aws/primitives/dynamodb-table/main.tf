resource "aws_dynamodb_table" "this" {
  name                        = var.name
  billing_mode                = var.billing_mode
  read_capacity               = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity              = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  hash_key                    = var.hash_key
  range_key                   = var.range_key
  table_class                 = var.table_class
  deletion_protection_enabled = var.deletion_protection_enabled
  stream_enabled              = var.stream_enabled
  stream_view_type            = var.stream_enabled ? var.stream_view_type : null

  dynamic "attribute" {
    for_each = local.deduplicated_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  server_side_encryption {
    enabled     = local.sse_enabled
    kms_key_arn = var.kms_key_arn
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  ttl {
    enabled        = var.ttl_enabled
    attribute_name = var.ttl_attribute_name
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.projection_type == "INCLUDE" ? global_secondary_index.value.non_key_attributes : null
      read_capacity      = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.read_capacity : null
      write_capacity     = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.write_capacity : null
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = local_secondary_index.value.projection_type == "INCLUDE" ? local_secondary_index.value.non_key_attributes : null
    }
  }

  tags = local.common_tags
}

resource "aws_appautoscaling_target" "read" {
  count = var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? 1 : 0

  max_capacity       = var.autoscaling_read_max_capacity
  min_capacity       = var.autoscaling_read_min_capacity
  resource_id        = local.autoscaling_resource_id
  scalable_dimension = local.autoscaling_read_scalable_dimension
  service_namespace  = local.autoscaling_service_namespace
}

resource "aws_appautoscaling_policy" "read" {
  count = var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? 1 : 0

  name               = "${var.name}-read-autoscaling"
  policy_type        = local.autoscaling_policy_type
  resource_id        = aws_appautoscaling_target.read[0].resource_id
  scalable_dimension = aws_appautoscaling_target.read[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.read[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = local.autoscaling_read_predefined_metric_type
    }
    target_value = var.autoscaling_read_target_value
  }
}

resource "aws_appautoscaling_target" "write" {
  count = var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? 1 : 0

  max_capacity       = var.autoscaling_write_max_capacity
  min_capacity       = var.autoscaling_write_min_capacity
  resource_id        = local.autoscaling_resource_id
  scalable_dimension = local.autoscaling_write_scalable_dimension
  service_namespace  = local.autoscaling_service_namespace
}

resource "aws_appautoscaling_policy" "write" {
  count = var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? 1 : 0

  name               = "${var.name}-write-autoscaling"
  policy_type        = local.autoscaling_policy_type
  resource_id        = aws_appautoscaling_target.write[0].resource_id
  scalable_dimension = aws_appautoscaling_target.write[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.write[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = local.autoscaling_write_predefined_metric_type
    }
    target_value = var.autoscaling_write_target_value
  }
}
