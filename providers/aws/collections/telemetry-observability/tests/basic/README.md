# Basic Example Tests

Terratest fixtures for `examples/basic/`. Asserted behavior:

- `OutputsPopulated` -- opensearch / grafana / indexer outputs are
  populated and have the expected ARN shapes; `alarms_topic_arn` is
  null/empty in the basic example
- `OpenSearchDomainExists` -- `DescribeDomain` returns the configured
  domain name
- `GrafanaWorkspaceExists` -- `DescribeWorkspace` returns the
  configured workspace id
- `IndexerLambdaExists` -- `GetFunction` returns the indexer Lambda's
  name/arn

## Running

```bash
make tf-test MODULE_PATH=providers/aws/collections/telemetry-observability
```
