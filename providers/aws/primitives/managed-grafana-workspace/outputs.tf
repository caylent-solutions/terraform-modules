output "workspace_id" {
  description = "The ID of the Grafana workspace."
  value       = aws_grafana_workspace.this.id
}

output "workspace_arn" {
  description = "The ARN of the Grafana workspace."
  value       = aws_grafana_workspace.this.arn
}

output "workspace_url" {
  description = "The endpoint URL of the Grafana workspace."
  value       = aws_grafana_workspace.this.endpoint
}
