resource "aws_appconfig_application" "this" {
  name        = var.name
  description = var.description
  tags        = var.tags
}

resource "aws_appconfig_environment" "this" {
  for_each = var.environments

  application_id = aws_appconfig_application.this.id
  name           = each.value.name
  description    = each.value.description

  dynamic "monitor" {
    for_each = lookup(each.value, "monitors", [])
    content {
      alarm_arn      = monitor.value.alarm_arn
      alarm_role_arn = lookup(monitor.value, "alarm_role_arn", null)
    }
  }

  tags = var.tags
}

resource "aws_appconfig_configuration_profile" "this" {
  for_each = var.configuration_profiles

  application_id = aws_appconfig_application.this.id
  name           = each.value.name
  description    = each.value.description
  type           = each.value.type
  location_uri   = coalesce(each.value.location_uri, local.location_uri_hosted)

  tags = var.tags
}

resource "aws_appconfig_deployment_strategy" "this" {
  count = var.create_deployment_strategy ? 1 : 0

  name                           = "${var.name}${local.deployment_strategy_name_suffix}"
  description                    = var.deployment_strategy_description
  deployment_duration_in_minutes = var.deployment_duration_in_minutes
  final_bake_time_in_minutes     = var.deployment_final_bake_time_in_minutes
  growth_factor                  = var.deployment_growth_factor
  growth_type                    = var.deployment_growth_type
  replicate_to                   = var.deployment_replicate_to

  tags = var.tags
}
