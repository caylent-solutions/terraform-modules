# secrets-manager-secret

AWS Secrets Manager secret primitive Terraform module.

Ships:

- `aws_secretsmanager_secret` with optional customer-managed KMS key, configurable recovery window, and cross-region replication
- Optional initial `aws_secretsmanager_secret_version` (sensitive)
- Optional `aws_secretsmanager_secret_rotation` with a configurable cadence (default 90 days per `spec/security.md`)
- Optional `aws_secretsmanager_secret_policy` for resource-based access policies

## Usage

```hcl
module "secret" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/secrets-manager-secret?ref=providers/aws/primitives/secrets-manager-secret/v0.1.0"

  name        = "telemetry/db/credentials"
  description = "Telemetry primary DB credentials"

  kms_key_id              = aws_kms_key.telemetry.arn
  recovery_window_in_days = 30

  initial_secret_string = jsonencode({ username = "telemetry", password = var.db_password })

  rotation_lambda_arn               = aws_lambda_function.rotator.arn
  rotation_automatically_after_days = 90

  tags = { Application = "telemetry" }
}
```

For a runnable example see [`examples/basic/`](examples/basic/README.md).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

## Testing

```bash
make tf-test MODULE_PATH=providers/aws/primitives/secrets-manager-secret
```
