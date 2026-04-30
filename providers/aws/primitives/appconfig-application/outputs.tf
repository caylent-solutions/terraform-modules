output "application_id" {
  description = "ID of the AppConfig application."
  value       = aws_appconfig_application.this.id
}

output "application_arn" {
  description = "ARN of the AppConfig application."
  value       = aws_appconfig_application.this.arn
}

output "application_name" {
  description = "Name of the AppConfig application."
  value       = aws_appconfig_application.this.name
}

output "environment_ids" {
  description = "Map of environment logical ids to AppConfig environment ids."
  value       = { for k, e in aws_appconfig_environment.this : k => e.environment_id }
}

output "environment_arns" {
  description = "Map of environment logical ids to AppConfig environment ARNs."
  value       = { for k, e in aws_appconfig_environment.this : k => e.arn }
}

output "configuration_profile_ids" {
  description = "Map of configuration profile logical ids to AppConfig configuration profile ids."
  value       = { for k, p in aws_appconfig_configuration_profile.this : k => p.configuration_profile_id }
}

output "configuration_profile_arns" {
  description = "Map of configuration profile logical ids to AppConfig configuration profile ARNs."
  value       = { for k, p in aws_appconfig_configuration_profile.this : k => p.arn }
}

output "deployment_strategy_id" {
  description = "ID of the deployment strategy, or null when create_deployment_strategy = false."
  value       = var.create_deployment_strategy ? aws_appconfig_deployment_strategy.this[0].id : null
}

output "deployment_strategy_arn" {
  description = "ARN of the deployment strategy, or null when create_deployment_strategy = false."
  value       = var.create_deployment_strategy ? aws_appconfig_deployment_strategy.this[0].arn : null
}
