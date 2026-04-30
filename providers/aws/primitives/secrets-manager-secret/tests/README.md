# secrets-manager-secret Module Tests

This directory contains Terratest tests for the `secrets-manager-secret` primitive module.

## Test Structure

- **basic/**: Tests for the basic example (KMS-encrypted secret, no rotation)

## Running Tests

Tests require real AWS credentials and deploy to a live AWS account.

```bash
# Install dependencies first
make cpm-configure
make install

# Run all tests
make test

# Run only the basic example tests
make test-basic

# Lint and format Go test files
make go-lint
make go-format
```

## Test Requirements

- Go >= 1.23
- Terraform >= 1.12.1
- AWS credentials with permission to create Secrets Manager secrets and KMS keys
- `AWS_GITHUB_ACTIONS_ROLE_ARN` environment variable set (or equivalent AWS auth)

## Test Coverage

| Test | Description |
|------|-------------|
| `TestBasicSecretCreation` | Verifies the secret ARN is non-empty and matches the expected ARN format |
| `TestBasicSecretKMSEncryption` | Verifies the `kms_key_id` output is non-empty (encryption required) |
| `TestBasicRequiredOutputs` | Verifies all required outputs (`secret_arn`, `secret_id`, `secret_name`, `kms_key_id`) are present |
| `TestBasicSecretResourceExists` | Verifies `aws_secretsmanager_secret.this` resource exists in Terraform state |
| `TestBasicIdempotency` | Verifies that re-applying produces no changes |
| `TestBasicTerraformVersion` | Verifies the Terraform version meets the `>= 1.12.1` requirement |
