# managed-grafana-workspace / basic example

Provisions a single Amazon Managed Grafana workspace with SERVICE_MANAGED
permissions, SAML authentication, and the CloudWatch data source.

## What it creates

- `module.workspace` -- one `aws_grafana_workspace` plus the IAM role the
  workspace assumes (the module manages it by default)

The example uses SAML rather than `AWS_SSO` so the test does not require
AWS Identity Center to be enabled in the test account. The module's own
default remains `["AWS_SSO"]` per the module spec.

## Apply

```bash
cd providers/aws/primitives/managed-grafana-workspace/examples/basic
terraform init
terraform apply -auto-approve
```

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).
