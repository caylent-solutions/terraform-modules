# Basic Example Tests

Terratest fixtures for `examples/basic/`. Asserted behavior:

- `RestApiExists` -- API ID, ARN, and stage name match outputs
- `EndpointTypeIsRegional` -- `GetRestApi` returns `REGIONAL`
- `StageHasMethodSettingsAndAccessLog` -- `*/*` method settings are
  configured (metrics enabled, logging level ERROR), access log group
  is wired
- `UsagePlanCreated` -- usage plan exists, references the API+stage,
  rate limit = 100
- `MockGetRouteReturns200` -- `curl ${stage_invoke_url}/` returns 200
  with the expected body

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/api-gateway-rest-api
```
