web_acl_name             = "test-telemetry-waf"
authorizer_function_name = "test-telemetry-authz"
api_name                 = "test-telemetry-api"
api_stage_name           = "prod"

tags = {
  ManagedBy = "terraform"
  Module    = "telemetry-api"
  Example   = "basic"
}
