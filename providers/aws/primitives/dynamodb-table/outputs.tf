output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = aws_dynamodb_table.this.arn
}

output "table_id" {
  description = "ID of the DynamoDB table (same as the table name)."
  value       = aws_dynamodb_table.this.id
}

output "table_name" {
  description = "Name of the DynamoDB table."
  value       = aws_dynamodb_table.this.name
}

output "stream_arn" {
  description = "ARN of the DynamoDB Streams endpoint, or null when stream_enabled = false."
  value       = var.stream_enabled ? aws_dynamodb_table.this.stream_arn : null
}

output "stream_label" {
  description = "Timestamp-based label of the DynamoDB Streams endpoint, or null when stream_enabled = false."
  value       = var.stream_enabled ? aws_dynamodb_table.this.stream_label : null
}

output "autoscaling_read_target_arn" {
  description = "Application Auto Scaling target ARN for table read capacity, or null when autoscaling is disabled."
  value       = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled ? aws_appautoscaling_target.table_read[0].arn : null
}

output "autoscaling_write_target_arn" {
  description = "Application Auto Scaling target ARN for table write capacity, or null when autoscaling is disabled."
  value       = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled ? aws_appautoscaling_target.table_write[0].arn : null
}
