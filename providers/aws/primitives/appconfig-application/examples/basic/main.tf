resource "random_id" "suffix" {
  byte_length = 4
}

module "appconfig" {
  source = "../../"

  name        = "${var.application_name}-${random_id.suffix.hex}"
  description = "Basic example for appconfig-application primitive"

  environments = {
    dev = {
      name        = "dev"
      description = "Development environment"
    }
    prod = {
      name        = "prod"
      description = "Production environment"
    }
  }

  configuration_profiles = {
    feature_flags = {
      name        = "feature-flags"
      description = "Feature flags for the basic example"
      type        = "AWS.AppConfig.FeatureFlags"
    }
  }

  create_deployment_strategy            = true
  deployment_strategy_description       = "Linear 5-step over 5 minutes"
  deployment_duration_in_minutes        = var.deployment_duration_in_minutes
  deployment_final_bake_time_in_minutes = var.deployment_final_bake_time_in_minutes
  deployment_growth_factor              = var.deployment_growth_factor
  deployment_growth_type                = var.deployment_growth_type

  tags = var.tags
}

output "application_id" {
  description = "AppConfig application ID."
  value       = module.appconfig.application_id
}

output "application_name" {
  description = "AppConfig application name."
  value       = module.appconfig.application_name
}

output "environment_ids" {
  description = "Map of environment logical ids to AppConfig environment ids."
  value       = module.appconfig.environment_ids
}

output "configuration_profile_ids" {
  description = "Map of configuration profile logical ids to AppConfig configuration profile ids."
  value       = module.appconfig.configuration_profile_ids
}

output "deployment_strategy_id" {
  description = "Deployment strategy ID."
  value       = module.appconfig.deployment_strategy_id
}
