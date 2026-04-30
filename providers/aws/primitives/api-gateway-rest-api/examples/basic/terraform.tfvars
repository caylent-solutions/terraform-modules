name                  = "telemetry-api"
stage_name            = "v1"
access_log_group_name = "/aws/apigateway/telemetry-api/v1"

description              = "Caylent Enterprise Telemetry REST API"
endpoint_type            = "REGIONAL"
minimum_compression_size = -1
xray_tracing_enabled     = true
metrics_enabled          = false
logging_level            = "INFO"
throttling_burst_limit   = -1
throttling_rate_limit    = -1
log_retention_in_days    = 30

tags = {
  Environment = "test"
  Purpose     = "api-gateway-rest-api-module-testing"
  Owner       = "terraform"
}
