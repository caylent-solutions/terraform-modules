output "table_arn" {
  description = "The ARN of the DynamoDB table."
  value       = aws_dynamodb_table.this.arn
}

output "table_id" {
  description = "The name of the DynamoDB table."
  value       = aws_dynamodb_table.this.id
}

output "table_name" {
  description = "The name of the DynamoDB table."
  value       = aws_dynamodb_table.this.name
}

output "table_hash_key" {
  description = "The hash key of the DynamoDB table."
  value       = aws_dynamodb_table.this.hash_key
}

output "table_range_key" {
  description = "The range key of the DynamoDB table."
  value       = aws_dynamodb_table.this.range_key
}

output "table_stream_arn" {
  description = "The ARN of the Table Stream. Only available when stream_enabled is true."
  value       = aws_dynamodb_table.this.stream_arn
}

output "table_stream_label" {
  description = "A timestamp, in ISO 8601 format, for the Table Stream. Only available when stream_enabled is true."
  value       = aws_dynamodb_table.this.stream_label
}

output "table_billing_mode" {
  description = "The billing mode of the DynamoDB table."
  value       = aws_dynamodb_table.this.billing_mode
}

output "table_tags_all" {
  description = "A map of tags assigned to the table, including those inherited from the provider default_tags configuration block."
  value       = aws_dynamodb_table.this.tags_all
}

output "autoscaling_read_target_arn" {
  description = "The ARN of the read auto-scaling target. Empty when autoscaling is disabled."
  value       = var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? aws_appautoscaling_target.read[0].arn : null
}

output "autoscaling_write_target_arn" {
  description = "The ARN of the write auto-scaling target. Empty when autoscaling is disabled."
  value       = var.autoscaling_enabled && var.billing_mode == "PROVISIONED" ? aws_appautoscaling_target.write[0].arn : null
}
