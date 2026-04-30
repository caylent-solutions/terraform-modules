# Module Tests

This directory contains tests for the `managed-grafana-workspace` Terraform module
using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

- **basic/**: Tests for the basic example -- provisions a minimal Grafana workspace with AWS SSO auth,
  using a dynamically generated workspace name (via `ExtraVars`) to prevent naming collisions across
  parallel test runs.

## Conditional Branch Coverage

The `managed-grafana-workspace` module contains three conditional resource branches in `main.tf`:

1. **SAML configuration** (`aws_grafana_workspace_saml_configuration`) -- created only when
   `auth_providers` contains `"SAML"`. The basic example uses `["AWS_SSO"]` only, so this branch
   is not exercised in the basic test.
2. **Admin/Viewer role associations** (`aws_grafana_role_association`) -- created only when
   `admin_sso_group_ids` or `viewer_sso_group_ids` are non-empty. The basic example provides
   empty lists, so this branch is not exercised.
3. **VPC configuration** (`dynamic "vpc_configuration"`) -- created only when `vpc_configuration`
   is non-null. The basic example omits this variable (defaults to null), so this branch is
   not exercised.

These branches are integration-tested only when additional examples (e.g., `examples/saml`,
`examples/vpc-connected`) are available. Adding such examples is outside the scope of the
initial module delivery (Changes Manifest covers `examples/basic/` only). If coverage of
these branches is required, a follow-up task should add dedicated examples and corresponding
test functions.

## Running Tests

```bash
# Run all tests
make test

# Lint Go test files
make go-lint

# Format Go test files
make go-format
```

## Test Requirements

- Go >= 1.24.4
- Terraform >= 1.12.1
- AWS credentials with permissions to create Grafana workspaces
- AWS IAM Identity Center (SSO) enabled in the target account

## Test Configuration

- **Idempotency**: Enabled (`TERRATEST_IDEMPOTENCY=true` in `test.config`)
- **Timeout**: 60 minutes
