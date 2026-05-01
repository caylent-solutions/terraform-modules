# Basic Example Tests

Terratest fixtures for `examples/basic/`. Asserted behavior:

- `OutputsPopulated` -- workspace id/arn/url and the module-managed role
  ARN are non-empty; ARN is a Grafana ARN; name has the configured prefix
- `WorkspaceShapeMatchesInputs` -- `DescribeWorkspace` returns
  `accountAccessType=CURRENT_ACCOUNT`, `permissionType=SERVICE_MANAGED`,
  authentication provider list contains `SAML`, data source list
  contains `CLOUDWATCH`, notification destinations contain `SNS`

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/managed-grafana-workspace
```
