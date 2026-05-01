# telemetry-observability / basic example

Provisions the `telemetry-observability` collection without alarms wiring:

- An OpenSearch domain (single t3.small.search node, public endpoint)
- A Managed Grafana workspace with SAML auth (avoids the AWS Identity
  Center prerequisite that AWS_SSO would impose)
- A small indexer Lambda (the example provides an `index.js` zip; in
  production a real bulk-index handler ships)

`alarms_topic_arn` is left null in this example. Consumers wire their own
SNS topic + CloudWatch alarm subscriptions in their root module.

## Apply

```bash
cd providers/aws/collections/telemetry-observability/examples/basic
terraform init
terraform apply -auto-approve
```

Note: provisioning runs ~15-20 minutes (OpenSearch domain + Grafana
workspace creation are slow).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).
