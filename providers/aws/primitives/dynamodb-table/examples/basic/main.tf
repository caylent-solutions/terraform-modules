module "dynamodb_table" {
  source = "../../"

  name          = var.name
  hash_key      = var.hash_key
  hash_key_type = var.hash_key_type

  point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
  ttl_enabled                    = var.ttl_enabled
  ttl_attribute_name             = var.ttl_attribute_name

  tags = var.tags
}

output "table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = module.dynamodb_table.table_arn
}

output "table_id" {
  description = "The name/ID of the DynamoDB table"
  value       = module.dynamodb_table.table_id
}

output "table_name" {
  description = "The name of the DynamoDB table"
  value       = module.dynamodb_table.table_name
}

output "table_hash_key" {
  description = "The hash key of the DynamoDB table"
  value       = module.dynamodb_table.table_hash_key
}

output "table_billing_mode" {
  description = "The billing mode of the DynamoDB table"
  value       = module.dynamodb_table.table_billing_mode
}

output "table_stream_arn" {
  description = "The ARN of the Table Stream"
  value       = module.dynamodb_table.table_stream_arn
}

output "table_tags_all" {
  description = "All tags assigned to the table"
  value       = module.dynamodb_table.table_tags_all
}
