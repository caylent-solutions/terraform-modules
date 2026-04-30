# api-gateway-rest-api

AWS API Gateway REST API primitive Terraform module.

Ships:

- `aws_api_gateway_rest_api` (REGIONAL, EDGE, or PRIVATE) with optional
  inline OpenAPI 3.0 body, binary media types, minimum compression
  size, API key source, and `disable_execute_api_endpoint`.
- `aws_api_gateway_deployment` keyed off the OpenAPI body, endpoint
  type, stage name, and api_key_source so changes redeploy
  automatically (`create_before_destroy = true`).
- `aws_api_gateway_stage` with X-Ray tracing, stage variables, optional
  cache cluster, and `aws_api_gateway_method_settings` (`*/*`) for
  metrics, logging level, data tracing, and throttling.
- Optional CloudWatch Log Group for stage access logs
  (`create_access_log_group = true`) with configurable retention and
  KMS key, OR an externally provisioned destination via
  `access_log_destination_arn`.
- Optional custom domain (`custom_domain_name` +
  `custom_domain_certificate_arn`) and base path mapping
  (`custom_domain_base_path`).
- Optional usage plan with throttle and quota settings, attached to
  the deployment stage.

## Usage

```hcl
module "api" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/api-gateway-rest-api?ref=providers/aws/primitives/api-gateway-rest-api/v0.1.0"

  name        = "telemetry-api"
  description = "Caylent telemetry ingest API"

  endpoint_type = "REGIONAL"
  openapi_body  = file("${path.module}/openapi/telemetry.json")

  stage_name             = "v1"
  xray_tracing_enabled   = true
  method_logging_level   = "ERROR"
  method_metrics_enabled = true

  create_access_log_group      = true
  access_log_retention_in_days = 30

  custom_domain_name            = "telemetry.example.com"
  custom_domain_certificate_arn = aws_acm_certificate.telemetry.arn
  custom_domain_security_policy = "TLS_1_2"

  create_usage_plan = true
  usage_plan_throttle = {
    burst_limit = 200
    rate_limit  = 1000
  }

  tags = {
    Application = "telemetry"
    Environment = "prod"
  }
}
```

For a runnable example see [`examples/basic/`](examples/basic/README.md).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md) (auto-generated).

## Testing

```bash
make tf-test MODULE_PATH=providers/aws/primitives/api-gateway-rest-api
```

See [tests/README.md](tests/README.md).
