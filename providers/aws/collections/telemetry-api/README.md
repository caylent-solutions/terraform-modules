# telemetry-api

AWS collection module composing the four primitives that make up the Caylent
telemetry ingest API:

- `waf-webacl` -- regional Web ACL fronting the API (managed AWS rule groups
  + per-IP rate limit by default)
- `lambda` -- HMAC-SHA256 authorizer Lambda function
- `api-gateway-rest-api` -- REST API + deployment stage, with optional
  custom domain
- `route53-record` -- alias record routing the custom domain at the API's
  regional endpoint (created only when `custom_domain_name` is set)

The collection wires the route53 alias record at the API Gateway custom
domain (regional name + zone). `aws_wafv2_web_acl_association` and
`aws_lambda_permission` for the API Gateway authorizer integration are NOT
wired by this module (collections cannot contain resource blocks per OPA's
`no_resources_policy`); instead, the collection exposes the relevant ARNs
(`web_acl_arn`, `stage_arn`, `authorizer_invoke_arn`,
`rest_api_execution_arn`) so the consumer can attach them in their own
root module.

## Usage

```hcl
module "telemetry_api" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/collections/telemetry-api?ref=providers/aws/collections/telemetry-api/v0.1.0"

  web_acl_name = "telemetry-prod-waf"

  authorizer_function_name = "telemetry-prod-authz"
  authorizer_role_arn      = aws_iam_role.authorizer.arn
  authorizer_filename      = data.archive_file.authorizer.output_path
  authorizer_handler       = "index.handler"
  authorizer_runtime       = "nodejs20.x"

  api_name         = "telemetry-prod"
  api_openapi_body = file("${path.module}/openapi.json")

  custom_domain_name            = "telemetry.example.com"
  custom_domain_certificate_arn = aws_acm_certificate.telemetry.arn
  route53_zone_id               = aws_route53_zone.public.zone_id

  tags = { Service = "telemetry" }
}

# Consumer wires the WAF association.
resource "aws_wafv2_web_acl_association" "telemetry" {
  resource_arn = module.telemetry_api.stage_arn
  web_acl_arn  = module.telemetry_api.web_acl_arn
}
```

For a runnable example see [`examples/basic/`](examples/basic/README.md).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

## Testing

```bash
make tf-test MODULE_PATH=providers/aws/collections/telemetry-api
```
