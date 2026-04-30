resource "random_id" "suffix" {
  byte_length = 4
}

module "table" {
  source = "../../"

  name = "${var.table_name}-${random_id.suffix.hex}"

  billing_mode = var.billing_mode

  hash_key  = var.hash_key
  range_key = var.range_key

  attributes               = var.attributes
  global_secondary_indexes = var.global_secondary_indexes

  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type

  ttl_attribute_name = var.ttl_attribute_name

  point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
  deletion_protection_enabled    = var.deletion_protection_enabled

  tags = var.tags
}

output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = module.table.table_arn
}

output "table_name" {
  description = "Name of the DynamoDB table."
  value       = module.table.table_name
}

output "stream_arn" {
  description = "ARN of the DynamoDB Streams endpoint, or null when stream_enabled = false."
  value       = module.table.stream_arn
}
