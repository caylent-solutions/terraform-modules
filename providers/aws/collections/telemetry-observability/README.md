# telemetry-observability

AWS collection module composing the three primitives that make up the
Caylent telemetry observability tier:

- `opensearch-domain` -- queryable index for telemetry events
- `managed-grafana-workspace` -- dashboards over CloudWatch /
  OpenSearch / X-Ray
- `lambda` -- OpenSearch indexer Lambda function

The spec brief also calls out a Slack-forwarder Lambda + CloudWatch
alarms + SNS topic, but those primitives are not yet shipped in this
repo. The collection therefore:

- Bundles OpenSearch + Grafana + a single indexer Lambda
- Accepts an externally-provisioned `alarms_topic_arn` as an optional
  input that is exposed verbatim on the corresponding output for
  consumer wiring
- Leaves CloudWatch alarm subscriptions and any Slack forwarder
  Lambda for the consumer's root module

## Usage

```hcl
module "telemetry_observability" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/collections/telemetry-observability?ref=providers/aws/collections/telemetry-observability/v0.1.0"

  opensearch_domain_name = "telemetry-prod-events"

  grafana_workspace_name           = "telemetry-prod-grafana"
  grafana_authentication_providers = ["AWS_SSO"]

  indexer_function_name = "telemetry-prod-indexer"
  indexer_role_arn      = aws_iam_role.indexer.arn
  indexer_filename      = data.archive_file.indexer.output_path
  indexer_handler       = "index.handler"
  indexer_runtime       = "nodejs20.x"

  alarms_topic_arn = aws_sns_topic.alarms.arn
}
```

For a runnable example see [`examples/basic/`](examples/basic/README.md).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

## Testing

```bash
make tf-test MODULE_PATH=providers/aws/collections/telemetry-observability
```
