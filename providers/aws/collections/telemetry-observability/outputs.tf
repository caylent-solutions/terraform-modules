output "opensearch_domain_endpoint" {
  description = "Endpoint URL of the OpenSearch domain."
  value       = module.opensearch.endpoint
}

output "opensearch_domain_arn" {
  description = "ARN of the OpenSearch domain."
  value       = module.opensearch.domain_arn
}

output "opensearch_domain_name" {
  description = "Name of the OpenSearch domain."
  value       = module.opensearch.domain_name
}

output "grafana_workspace_url" {
  description = "Endpoint URL of the Managed Grafana workspace."
  value       = module.grafana.workspace_url
}

output "grafana_workspace_id" {
  description = "Identifier of the Managed Grafana workspace."
  value       = module.grafana.workspace_id
}

output "grafana_workspace_arn" {
  description = "ARN of the Managed Grafana workspace."
  value       = module.grafana.workspace_arn
}

output "indexer_function_name" {
  description = "Name of the OpenSearch indexer Lambda."
  value       = module.indexer.function_name
}

output "indexer_function_arn" {
  description = "ARN of the OpenSearch indexer Lambda."
  value       = module.indexer.arn
}

output "indexer_invoke_arn" {
  description = "Invoke ARN of the OpenSearch indexer Lambda (for event source mappings)."
  value       = module.indexer.invoke_arn
}

output "alarms_topic_arn" {
  description = "Pass-through of the consumer-supplied SNS topic ARN that downstream CloudWatch alarms publish to. Null when not configured."
  value       = var.alarms_topic_arn
}
