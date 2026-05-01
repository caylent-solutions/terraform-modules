output "opensearch_domain_endpoint" {
  description = "Endpoint URL of the OpenSearch domain."
  value       = module.telemetry_observability.opensearch_domain_endpoint
}

output "opensearch_domain_name" {
  description = "Name of the OpenSearch domain."
  value       = module.telemetry_observability.opensearch_domain_name
}

output "opensearch_domain_arn" {
  description = "ARN of the OpenSearch domain."
  value       = module.telemetry_observability.opensearch_domain_arn
}

output "grafana_workspace_url" {
  description = "Grafana workspace endpoint URL."
  value       = module.telemetry_observability.grafana_workspace_url
}

output "grafana_workspace_id" {
  description = "Grafana workspace identifier."
  value       = module.telemetry_observability.grafana_workspace_id
}

output "grafana_workspace_arn" {
  description = "Grafana workspace ARN."
  value       = module.telemetry_observability.grafana_workspace_arn
}

output "indexer_function_name" {
  description = "Indexer Lambda function name."
  value       = module.telemetry_observability.indexer_function_name
}

output "indexer_function_arn" {
  description = "Indexer Lambda function ARN."
  value       = module.telemetry_observability.indexer_function_arn
}

output "alarms_topic_arn" {
  description = "Pass-through SNS topic ARN (null in the basic example)."
  value       = module.telemetry_observability.alarms_topic_arn
}
