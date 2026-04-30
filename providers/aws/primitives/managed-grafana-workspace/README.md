# managed-grafana-workspace

Amazon Managed Grafana workspace primitive module for the Caylent Enterprise Telemetry System.

This module provisions an Amazon Managed Grafana workspace with configurable authentication
providers (AWS SSO and/or SAML), data source connections (OpenSearch, CloudWatch, X-Ray, and
others), notification destinations, IAM Identity Center role associations, and optional VPC
connectivity.

## Usage

```hcl
module "grafana_workspace" {
  source = "git::ssh://git@github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/managed-grafana-workspace?ref=providers/aws/primitives/managed-grafana-workspace/v0.1.0"

  workspace_name      = "my-grafana-workspace"
  account_access_type = "CURRENT_ACCOUNT"
  auth_providers      = ["AWS_SSO"]
  permission_type     = "SERVICE_MANAGED"

  data_sources = [
    "AMAZON_OPENSEARCH_SERVICE",
    "CLOUDWATCH",
    "XRAY",
  ]

  notification_destinations = ["SNS"]

  admin_sso_group_ids  = ["group-id-admin"]
  viewer_sso_group_ids = ["group-id-viewer"]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Examples

- [basic](./examples/basic/) -- Minimal configuration using AWS SSO authentication

## Inputs

See [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for the full list of inputs and outputs.

## Outputs

| Name | Description |
|------|-------------|
| workspace_id | The ID of the Grafana workspace |
| workspace_arn | The ARN of the Grafana workspace |
| workspace_url | The endpoint URL of the Grafana workspace |

## Requirements

- Terraform >= 1.12.1
- AWS provider >= 5.82.0

## Notes

- `CHANGELOG.md` and `VERSION` are managed automatically by the release workflow.
- All resource names are driven by variables; no hardcoded string literals appear in resource blocks.
- The module follows OPA-enforced file structure policies for the Caylent terraform-modules monorepo.
