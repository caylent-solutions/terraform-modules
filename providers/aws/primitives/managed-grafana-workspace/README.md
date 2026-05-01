# managed-grafana-workspace

AWS Amazon Managed Grafana workspace primitive Terraform module.

Ships:

- `aws_grafana_workspace` configured with `account_access_type`,
  `authentication_providers`, `permission_type`, `data_sources`,
  `notification_destinations`, and (optionally) a VPC configuration
- A module-managed `aws_iam_role` (assumed by `grafana.amazonaws.com`)
  for the workspace, with an opt-out toggle to bring your own role
- Optional `aws_grafana_role_association` blocks for AWS SSO group
  bindings to the workspace's `ADMIN`, `EDITOR`, and `VIEWER` roles

## Usage

```hcl
module "grafana" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/managed-grafana-workspace?ref=providers/aws/primitives/managed-grafana-workspace/v0.1.0"

  workspace_name = "telemetry-grafana"
  description    = "Telemetry analysis workspace"

  authentication_providers = ["AWS_SSO"]
  data_sources             = ["AMAZON_OPENSEARCH_SERVICE", "CLOUDWATCH", "XRAY"]

  admin_sso_group_ids  = ["12345678-1234-1234-1234-123456789012"]
  viewer_sso_group_ids = ["abcdef01-2345-6789-abcd-ef0123456789"]

  tags = {
    Service = "telemetry"
  }
}
```

For a runnable example see [`examples/basic/`](examples/basic/README.md).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

## Testing

```bash
make tf-test MODULE_PATH=providers/aws/primitives/managed-grafana-workspace
```
