output "workspace_id" {
  description = "The ID of the Grafana workspace"
  value       = module.grafana_workspace.workspace_id
}

output "workspace_arn" {
  description = "The ARN of the Grafana workspace"
  value       = module.grafana_workspace.workspace_arn
}

output "workspace_url" {
  description = "The endpoint URL of the Grafana workspace"
  value       = module.grafana_workspace.workspace_url
}
