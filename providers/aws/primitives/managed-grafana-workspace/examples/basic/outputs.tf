output "workspace_id" {
  description = "Identifier of the workspace."
  value       = module.workspace.workspace_id
}

output "workspace_arn" {
  description = "ARN of the workspace."
  value       = module.workspace.workspace_arn
}

output "workspace_url" {
  description = "Endpoint URL of the workspace."
  value       = module.workspace.workspace_url
}

output "workspace_role_arn" {
  description = "ARN of the IAM role assumed by the workspace."
  value       = module.workspace.workspace_role_arn
}

output "workspace_name" {
  description = "Configured name of the workspace (with random suffix)."
  value       = "${var.workspace_name}-${random_id.suffix.hex}"
}
