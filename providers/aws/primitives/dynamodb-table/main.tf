resource "aws_dynamodb_table" "this" {
  name         = var.name
  billing_mode = var.billing_mode

  hash_key  = var.hash_key
  range_key = var.range_key

  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_enabled ? var.stream_view_type : null

  table_class                 = var.table_class
  deletion_protection_enabled = var.deletion_protection_enabled

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      read_capacity      = var.billing_mode == "PROVISIONED" ? lookup(global_secondary_index.value, "read_capacity", null) : null
      write_capacity     = var.billing_mode == "PROVISIONED" ? lookup(global_secondary_index.value, "write_capacity", null) : null
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }

  dynamic "ttl" {
    for_each = var.ttl_attribute_name == null ? [] : [1]
    content {
      attribute_name = var.ttl_attribute_name
      enabled        = local.always_enabled
    }
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  server_side_encryption {
    enabled     = local.always_enabled
    kms_key_arn = var.kms_key_arn
  }

  tags = var.tags
}

resource "aws_appautoscaling_target" "table_read" {
  count = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled ? 1 : 0

  max_capacity       = var.autoscaling_read_max_capacity
  min_capacity       = var.autoscaling_read_min_capacity
  resource_id        = "${local.resource_id_prefix}${aws_dynamodb_table.this.name}"
  scalable_dimension = local.scalable_dimension_table_read
  service_namespace  = local.service_namespace
}

resource "aws_appautoscaling_policy" "table_read" {
  count = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled ? 1 : 0

  name               = "${var.name}${local.autoscaling_policy_name_read_suffix}"
  policy_type        = local.policy_type_target_tracking
  resource_id        = aws_appautoscaling_target.table_read[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_read[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_read[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.autoscaling_target_utilization

    predefined_metric_specification {
      predefined_metric_type = local.predefined_metric_read
    }
  }
}

resource "aws_appautoscaling_target" "table_write" {
  count = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled ? 1 : 0

  max_capacity       = var.autoscaling_write_max_capacity
  min_capacity       = var.autoscaling_write_min_capacity
  resource_id        = "${local.resource_id_prefix}${aws_dynamodb_table.this.name}"
  scalable_dimension = local.scalable_dimension_table_write
  service_namespace  = local.service_namespace
}

resource "aws_appautoscaling_policy" "table_write" {
  count = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled ? 1 : 0

  name               = "${var.name}${local.autoscaling_policy_name_write_suffix}"
  policy_type        = local.policy_type_target_tracking
  resource_id        = aws_appautoscaling_target.table_write[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_write[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_write[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.autoscaling_target_utilization

    predefined_metric_specification {
      predefined_metric_type = local.predefined_metric_write
    }
  }
}
