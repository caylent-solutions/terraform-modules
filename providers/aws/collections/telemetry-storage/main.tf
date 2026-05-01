module "queue" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/sqs-queue?ref=providers/aws/primitives/sqs-queue/v0.1.0"

  name                          = var.queue_name
  message_retention_seconds     = var.queue_message_retention_seconds
  visibility_timeout_seconds    = var.queue_visibility_timeout_seconds
  receive_wait_time_seconds     = var.queue_receive_wait_time_seconds
  delay_seconds                 = var.queue_delay_seconds
  max_message_size              = var.queue_max_message_size
  kms_master_key_id             = var.queue_kms_master_key_id
  sqs_managed_sse_enabled       = var.queue_sqs_managed_sse_enabled
  create_dlq                    = var.queue_create_dlq
  max_receive_count             = var.queue_max_receive_count
  dlq_message_retention_seconds = var.queue_dlq_message_retention_seconds
  create_dlq_depth_alarm        = var.queue_create_dlq_depth_alarm
  dlq_depth_alarm_threshold     = var.queue_dlq_depth_alarm_threshold
  dlq_depth_alarm_actions       = var.queue_dlq_depth_alarm_actions
  dlq_depth_alarm_ok_actions    = var.queue_dlq_depth_alarm_ok_actions

  tags = var.tags
}

module "table" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/dynamodb-table?ref=providers/aws/primitives/dynamodb-table/v0.1.0"

  name                           = var.table_name
  billing_mode                   = var.table_billing_mode
  hash_key                       = var.table_hash_key
  range_key                      = var.table_range_key
  attributes                     = var.table_attributes
  global_secondary_indexes       = var.table_global_secondary_indexes
  local_secondary_indexes        = var.table_local_secondary_indexes
  read_capacity                  = var.table_read_capacity
  write_capacity                 = var.table_write_capacity
  stream_enabled                 = var.table_stream_enabled
  stream_view_type               = var.table_stream_view_type
  table_class                    = var.table_class
  ttl_attribute_name             = var.table_ttl_attribute_name
  point_in_time_recovery_enabled = var.table_point_in_time_recovery_enabled
  deletion_protection_enabled    = var.table_deletion_protection_enabled
  kms_key_arn                    = var.table_kms_key_arn

  tags = var.tags
}

module "bus" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/eventbridge-bus?ref=providers/aws/primitives/eventbridge-bus/v0.1.0"

  name               = var.bus_name
  kms_key_identifier = var.bus_kms_key_identifier
  rules              = var.bus_rules
  targets            = var.bus_targets

  tags = var.tags
}
