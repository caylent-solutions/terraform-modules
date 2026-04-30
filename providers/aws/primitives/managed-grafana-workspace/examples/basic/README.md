# Example: basic

Minimal Amazon Managed Grafana workspace using AWS SSO authentication with SERVICE_MANAGED
permissions and a standard set of data sources (OpenSearch, CloudWatch, X-Ray).

## Usage

```bash
cd examples/basic
terraform init
terraform plan
terraform apply
```

## What This Example Creates

- An Amazon Managed Grafana workspace named `test-grafana-basic`
- AWS SSO as the authentication provider
- Service-managed permissions
- Data sources: Amazon OpenSearch Service, CloudWatch, X-Ray

## Requirements

- AWS credentials with permissions to create Grafana workspaces
- AWS IAM Identity Center (SSO) enabled in the account

## Inputs

| Name | Value |
|------|-------|
| workspace_name | test-grafana-basic |
| account_access_type | CURRENT_ACCOUNT |
| auth_providers | ["AWS_SSO"] |
| permission_type | SERVICE_MANAGED |
| data_sources | ["AMAZON_OPENSEARCH_SERVICE", "CLOUDWATCH", "XRAY"] |

## Outputs

| Name | Description |
|------|-------------|
| workspace_id | The Grafana workspace ID |
| workspace_arn | The Grafana workspace ARN |
| workspace_url | The Grafana workspace endpoint URL |
