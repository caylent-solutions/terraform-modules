# secrets-manager-secret

Terraform primitive module that provisions an AWS Secrets Manager secret with KMS encryption
and optional automatic rotation via a Lambda function.

This module is part of the Caylent Enterprise Telemetry System and satisfies the 90-day
rotation schedule requirement defined in the platform security policy.

## Features

- Creates an `aws_secretsmanager_secret` resource encrypted with a caller-supplied KMS key
- Enforces encryption at rest: `kms_key_id` is a required input
- Optionally configures automatic rotation via `aws_secretsmanager_secret_rotation`
- Configurable recovery window (0 for force-delete, or 7-30 days)
- Consistent tagging via `ManagedBy` and `Module` tags merged with caller-supplied tags

## Usage

```hcl
module "secret" {
  source = "git::ssh://git@github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/secrets-manager-secret?ref=providers/aws/primitives/secrets-manager-secret/v0.1.0"

  name       = "my-service-api-key"
  kms_key_id = aws_kms_key.this.arn
}
```

### With rotation

```hcl
module "secret" {
  source = "git::ssh://git@github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/secrets-manager-secret?ref=providers/aws/primitives/secrets-manager-secret/v0.1.0"

  name                = "my-service-api-key"
  kms_key_id          = aws_kms_key.this.arn
  enable_rotation     = true
  rotation_lambda_arn = aws_lambda_function.rotator.arn
  rotation_days       = 90
}
```

## Prerequisites

- Terraform >= 1.12.1
- AWS provider ~> 6.0.0
- A pre-existing KMS key ARN (caller manages the KMS key lifecycle)

## Getting Started

```bash
# Install CPM packages and Go dependencies
make cpm-configure
make install

# Run tests (requires AWS credentials)
make test

# Lint and format checks
make tf-lint
make tf-format
make go-lint
make go-format
```

## Module Structure

```
secrets-manager-secret/
├── examples/
│   └── basic/           # Minimal example: KMS key + secret, no rotation
├── tests/
│   └── basic/           # Terratest suite for the basic example
├── main.tf              # aws_secretsmanager_secret + aws_secretsmanager_secret_rotation
├── variables.tf         # Input variables
├── outputs.tf           # Outputs: secret_arn, secret_id, secret_name, kms_key_id, rotation_enabled, tags_all
├── versions.tf          # required_version >= 1.12.1, hashicorp/aws ~> 6.0.0
├── locals.tf            # common_tags merge
└── Makefile             # CPM-provided automation
```

## Inputs

See [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for the auto-generated inputs/outputs table.

### Required

| Name | Type | Description |
|------|------|-------------|
| `name` | `string` | Friendly name of the secret (1-512 characters, unique per account/region) |
| `kms_key_id` | `string` | ARN or ID of the KMS key used to encrypt the secret |

### Optional

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `description` | `string` | `null` | Human-readable description of the secret |
| `recovery_window_in_days` | `number` | `30` | Days before permanent deletion (0 or 7-30) |
| `enable_rotation` | `bool` | `false` | Enable automatic rotation |
| `rotation_lambda_arn` | `string` | `null` | ARN of the rotation Lambda (required when `enable_rotation = true`) |
| `rotation_days` | `number` | `90` | Days between automatic rotations (1-365) |
| `tags` | `map(string)` | `{}` | Additional tags to merge onto the secret |
| `managed_by_tag` | `string` | `"terraform"` | Value for the `ManagedBy` tag |
| `module_tag` | `string` | `"secrets-manager-secret"` | Value for the `Module` tag |

## Outputs

| Name | Description |
|------|-------------|
| `secret_arn` | ARN of the Secrets Manager secret |
| `secret_id` | ID of the secret (same as ARN) |
| `secret_name` | Friendly name of the secret |
| `kms_key_id` | ARN or ID of the KMS key used for encryption |
| `rotation_enabled` | Whether automatic rotation is enabled |
| `tags_all` | All tags assigned to the secret (including provider default_tags) |

## Security

- Encryption at rest is mandatory: `kms_key_id` has no default and must be supplied by the caller
- No inline IAM policies -- the module does not create or modify IAM resources
- No `#checkov:skip` or `#tfsec:ignore` suppressions are used

## References

- [AWS Secrets Manager Terraform resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret)
- [AWS Secrets Manager rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation)
- [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework)
