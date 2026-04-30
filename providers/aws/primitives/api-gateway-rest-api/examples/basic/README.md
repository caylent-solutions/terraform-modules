# api-gateway-rest-api / basic example

Provisions a REGIONAL REST API with a single `GET /` route backed by a
MOCK integration that always returns HTTP 200. The example also creates
the auto-managed access log group and a usage plan with rate/burst
throttling.

## What it creates

- `module.api` -- the `api-gateway-rest-api` primitive, configured with:
  - REGIONAL endpoint
  - Inline OpenAPI 3.0 body with `GET /` -> mock integration
  - Stage `v1` with metrics, ERROR-level logging, X-Ray off
  - Auto-created access log group (7-day retention)
  - Usage plan with `burst_limit = 50`, `rate_limit = 100`

## Apply

```bash
cd providers/aws/primitives/api-gateway-rest-api/examples/basic
terraform init
terraform apply -auto-approve
```

## Outputs

- `rest_api_id`, `rest_api_arn`
- `stage_name`, `stage_arn`, `stage_invoke_url`
- `access_log_group_arn`
- `usage_plan_id`

After apply, `curl ${stage_invoke_url}/` returns HTTP 200 with body
`{"message":"hello from api-gateway-rest-api basic example"}`.

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).
