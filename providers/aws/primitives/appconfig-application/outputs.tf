output "application_id" {
  description = "The ID of the AppConfig application."
  value       = aws_appconfig_application.this.id
}

output "application_arn" {
  description = "The ARN of the AppConfig application."
  value       = aws_appconfig_application.this.arn
}

output "application_name" {
  description = "The name of the AppConfig application."
  value       = aws_appconfig_application.this.name
}

output "environment_id" {
  description = "The ID of the AppConfig environment."
  value       = aws_appconfig_environment.this.environment_id
}

output "environment_arn" {
  description = "The ARN of the AppConfig environment."
  value       = aws_appconfig_environment.this.arn
}

output "environment_name" {
  description = "The name of the AppConfig environment."
  value       = aws_appconfig_environment.this.name
}

output "configuration_profile_id" {
  description = "The configuration profile ID."
  value       = aws_appconfig_configuration_profile.this.configuration_profile_id
}

output "configuration_profile_arn" {
  description = "The ARN of the AppConfig configuration profile."
  value       = aws_appconfig_configuration_profile.this.arn
}

output "configuration_profile_name" {
  description = "The name of the AppConfig configuration profile."
  value       = aws_appconfig_configuration_profile.this.name
}

output "deployment_strategy_id" {
  description = "The ID of the AppConfig deployment strategy."
  value       = aws_appconfig_deployment_strategy.this.id
}

output "deployment_strategy_arn" {
  description = "The ARN of the AppConfig deployment strategy."
  value       = aws_appconfig_deployment_strategy.this.arn
}

output "deployment_strategy_name" {
  description = "The name of the AppConfig deployment strategy."
  value       = aws_appconfig_deployment_strategy.this.name
}
