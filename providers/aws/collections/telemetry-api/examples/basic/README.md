# telemetry-api / basic example

Provisions the `telemetry-api` collection without a custom domain. The example
provides:

- An IAM execution role for the authorizer Lambda (basic CloudWatch Logs writes)
- A minimal `index.js` zip artifact for the Lambda (the production deployment
  ships an HMAC-SHA256 verifier; the example just needs a deployable artifact
  so the collection can compose around it)
- A minimal OpenAPI body for the REST API with a single `POST /events` mock

## What it creates

- `module.telemetry_api.module.waf` -- WAF Web ACL (regional)
- `module.telemetry_api.module.lambda_authorizer` -- HMAC authorizer Lambda
- `module.telemetry_api.module.api` -- REST API + deployment + stage

## Apply

```bash
cd providers/aws/collections/telemetry-api/examples/basic
terraform init
terraform apply -auto-approve
```

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).
