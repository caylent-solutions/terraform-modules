module "appconfig" {
  source = "../../"

  name                              = var.name
  description                       = var.description
  environment_name                  = var.environment_name
  environment_description           = var.environment_description
  configuration_profile_name        = var.configuration_profile_name
  configuration_profile_description = var.configuration_profile_description
  deployment_strategy_name          = var.deployment_strategy_name
  deployment_strategy_description   = var.deployment_strategy_description
  deployment_duration_in_minutes    = var.deployment_duration_in_minutes
  growth_factor                     = var.growth_factor
  growth_type                       = var.growth_type
  replicate_to                      = var.replicate_to
  final_bake_time_in_minutes        = var.final_bake_time_in_minutes
  tags                              = var.tags
}

output "application_id" {
  description = "The ID of the AppConfig application."
  value       = module.appconfig.application_id
}

output "application_arn" {
  description = "The ARN of the AppConfig application."
  value       = module.appconfig.application_arn
}

output "application_name" {
  description = "The name of the AppConfig application."
  value       = module.appconfig.application_name
}

output "environment_id" {
  description = "The ID of the AppConfig environment."
  value       = module.appconfig.environment_id
}

output "environment_arn" {
  description = "The ARN of the AppConfig environment."
  value       = module.appconfig.environment_arn
}

output "environment_name" {
  description = "The name of the AppConfig environment."
  value       = module.appconfig.environment_name
}

output "configuration_profile_id" {
  description = "The configuration profile ID."
  value       = module.appconfig.configuration_profile_id
}

output "configuration_profile_arn" {
  description = "The ARN of the AppConfig configuration profile."
  value       = module.appconfig.configuration_profile_arn
}

output "configuration_profile_name" {
  description = "The name of the AppConfig configuration profile."
  value       = module.appconfig.configuration_profile_name
}

output "deployment_strategy_id" {
  description = "The ID of the AppConfig deployment strategy."
  value       = module.appconfig.deployment_strategy_id
}

output "deployment_strategy_arn" {
  description = "The ARN of the AppConfig deployment strategy."
  value       = module.appconfig.deployment_strategy_arn
}

output "deployment_strategy_name" {
  description = "The name of the AppConfig deployment strategy."
  value       = module.appconfig.deployment_strategy_name
}
