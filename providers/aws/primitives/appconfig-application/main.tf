resource "aws_appconfig_application" "this" {
  name        = var.name
  description = var.description
  tags        = local.common_tags
}

resource "aws_appconfig_environment" "this" {
  name           = var.environment_name
  description    = var.environment_description
  application_id = aws_appconfig_application.this.id
  tags           = local.common_tags
}

resource "aws_appconfig_configuration_profile" "this" {
  name           = var.configuration_profile_name
  description    = var.configuration_profile_description
  application_id = aws_appconfig_application.this.id
  location_uri   = var._configuration_profile_location_uri
  type           = var._configuration_profile_type
  tags           = local.common_tags
}

resource "aws_appconfig_deployment_strategy" "this" {
  name                           = var.deployment_strategy_name
  description                    = var.deployment_strategy_description
  deployment_duration_in_minutes = var.deployment_duration_in_minutes
  final_bake_time_in_minutes     = var.final_bake_time_in_minutes
  growth_factor                  = var.growth_factor
  growth_type                    = var.growth_type
  replicate_to                   = var.replicate_to
  tags                           = local.common_tags
}
