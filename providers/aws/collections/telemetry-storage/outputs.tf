output "queue_url" {
  description = "URL of the primary ingest queue."
  value       = module.queue.queue_url
}

output "queue_arn" {
  description = "ARN of the primary ingest queue."
  value       = module.queue.queue_arn
}

output "queue_name" {
  description = "Name of the primary ingest queue."
  value       = module.queue.queue_name
}

output "dlq_url" {
  description = "URL of the dead-letter queue, or null when queue_create_dlq is false."
  value       = module.queue.dlq_url
}

output "dlq_arn" {
  description = "ARN of the dead-letter queue, or null when queue_create_dlq is false."
  value       = module.queue.dlq_arn
}

output "table_name" {
  description = "Name of the DynamoDB table."
  value       = module.table.table_name
}

output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = module.table.table_arn
}

output "table_stream_arn" {
  description = "ARN of the DynamoDB stream, or null when table_stream_enabled is false."
  value       = module.table.stream_arn
}

output "bus_arn" {
  description = "ARN of the EventBridge bus."
  value       = module.bus.bus_arn
}

output "bus_name" {
  description = "Name of the EventBridge bus."
  value       = module.bus.bus_name
}
