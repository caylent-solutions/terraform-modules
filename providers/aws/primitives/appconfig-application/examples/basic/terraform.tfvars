name                              = "telemetry-app"
description                       = "AppConfig application for telemetry feature flags"
environment_name                  = "production"
environment_description           = "Production environment for telemetry"
configuration_profile_name        = "feature-flags"
configuration_profile_description = "Feature flags configuration profile"
deployment_strategy_name          = "linear-5step-5min"
deployment_strategy_description   = "Linear deployment over 5 steps in 5 minutes"
deployment_duration_in_minutes    = 5
growth_factor                     = 20
growth_type                       = "LINEAR"
replicate_to                      = "NONE"
final_bake_time_in_minutes        = 0
tags = {
  Environment = "test"
  Purpose     = "appconfig-module-testing"
  Owner       = "terraform"
}
