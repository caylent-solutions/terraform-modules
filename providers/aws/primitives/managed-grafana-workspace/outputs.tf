output "workspace_id" {
  description = "Identifier of the Managed Grafana workspace."
  value       = aws_grafana_workspace.this.id
}

output "workspace_arn" {
  description = "ARN of the Managed Grafana workspace."
  value       = aws_grafana_workspace.this.arn
}

output "workspace_url" {
  description = "Endpoint URL of the Managed Grafana workspace."
  value       = aws_grafana_workspace.this.endpoint
}

output "workspace_role_arn" {
  description = "ARN of the IAM role assumed by the workspace (module-managed when create_workspace_role = true; otherwise the value passed via workspace_role_arn)."
  value       = var.create_workspace_role ? aws_iam_role.workspace[0].arn : var.workspace_role_arn
}
