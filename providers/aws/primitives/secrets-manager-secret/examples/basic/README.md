# Basic Example

This directory contains a basic example of the `secrets-manager-secret` Terraform module. It provisions an AWS Secrets Manager secret encrypted with a dedicated KMS key, with no rotation configured.

## Usage

```hcl
module "secret" {
  source = "git::ssh://git@github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/secrets-manager-secret?ref=providers/aws/primitives/secrets-manager-secret/v0.1.0"

  name                    = "my-service-secret"
  description             = "Secret for my service"
  kms_key_id              = aws_kms_key.this.arn
  recovery_window_in_days = 7
}
```

## Requirements

- Terraform >= 1.12.1
- AWS provider ~> 6.0.0
- AWS credentials configured

## Required Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Friendly name of the Secrets Manager secret. | `string` | `"telemetry-basic-secret"` | no |
| description | Description of the secret. | `string` | `"Basic example secret..."` | no |
| recovery\_window\_in\_days | Days before permanent deletion. | `number` | `7` | no |
| enable\_rotation | Whether to enable automatic rotation. | `bool` | `false` | no |
| rotation\_lambda\_arn | ARN of the rotation Lambda. | `string` | `null` | no |
| rotation\_days | Days between automatic rotations. | `number` | `90` | no |
| tags | Tags to apply to all resources. | `map(string)` | see tfvars | no |

## Outputs

| Name | Description |
|------|-------------|
| secret\_arn | The ARN of the Secrets Manager secret. |
| secret\_id | The ID of the Secrets Manager secret. |
| secret\_name | The friendly name of the Secrets Manager secret. |
| kms\_key\_id | The ARN of the KMS key used to encrypt the secret. |
| rotation\_enabled | Whether automatic rotation is enabled. |
| tags\_all | All tags assigned to the secret. |

## Testing

This example is tested as part of the module's test suite:

```bash
cd ../../
make test-basic
```

Refer to [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for auto-generated technical documentation.
