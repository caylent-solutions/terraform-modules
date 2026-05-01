output "queue_url" {
  description = "URL of the primary ingest queue."
  value       = module.telemetry_storage.queue_url
}

output "queue_arn" {
  description = "ARN of the primary ingest queue."
  value       = module.telemetry_storage.queue_arn
}

output "queue_name" {
  description = "Name of the primary ingest queue."
  value       = module.telemetry_storage.queue_name
}

output "dlq_url" {
  description = "URL of the dead-letter queue."
  value       = module.telemetry_storage.dlq_url
}

output "dlq_arn" {
  description = "ARN of the dead-letter queue."
  value       = module.telemetry_storage.dlq_arn
}

output "table_name" {
  description = "Name of the DynamoDB table."
  value       = module.telemetry_storage.table_name
}

output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = module.telemetry_storage.table_arn
}

output "bus_name" {
  description = "Name of the EventBridge bus."
  value       = module.telemetry_storage.bus_name
}

output "bus_arn" {
  description = "ARN of the EventBridge bus."
  value       = module.telemetry_storage.bus_arn
}
