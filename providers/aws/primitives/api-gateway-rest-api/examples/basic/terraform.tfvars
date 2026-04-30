api_name      = "test-api-gw-rest"
endpoint_type = "REGIONAL"
stage_name    = "v1"

xray_tracing_enabled   = false
method_metrics_enabled = true
method_logging_level   = "ERROR"

create_access_log_group      = true
access_log_retention_in_days = 7

create_account_cloudwatch_role = true

create_usage_plan = true

tags = {
  Environment = "test"
  ManagedBy   = "terraform"
}
