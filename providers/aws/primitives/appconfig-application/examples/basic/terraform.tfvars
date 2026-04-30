application_name = "test-appconfig-app"

deployment_duration_in_minutes        = 5
deployment_final_bake_time_in_minutes = 5
deployment_growth_factor              = 20
deployment_growth_type                = "LINEAR"

tags = {
  Environment = "test"
  ManagedBy   = "terraform"
}
