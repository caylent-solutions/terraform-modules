# Basic API Gateway REST API Example

This example demonstrates the basic usage of the `api-gateway-rest-api` module with minimal configuration.
It creates a Regional REST API with a single deployment stage, default method settings, and no custom domain or WAF.

## Usage

```hcl
resource "aws_cloudwatch_log_group" "api_access_logs" {
  name              = "/aws/apigateway/telemetry-api/v1"
  retention_in_days = 30
}

module "api_gateway_rest_api" {
  source = "../../"

  name       = "telemetry-api"
  stage_name = "v1"
  access_log_destination_arn = aws_cloudwatch_log_group.api_access_logs.arn
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.12.1 |
| aws | ~> 6.0.0 |

## Inputs

Refer to [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for all inputs and outputs.

## Testing

This example is tested as part of the module's test suite. To run tests specifically for this example:

```bash
cd ../../
make test
```
