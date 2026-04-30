# Basic Example Tests

This directory contains Terratest tests for the `basic` example of the `secrets-manager-secret` module.

## What Is Tested

The basic example deploys an AWS Secrets Manager secret encrypted with a dedicated KMS key and
no rotation configured.

### Test Functions

| Test | Assertion |
|------|-----------|
| `TestBasicSecretCreation` | `secret_arn` is non-empty and matches the `arn:aws:secretsmanager:...` format |
| `TestBasicSecretKMSEncryption` | `kms_key_id` output is non-empty -- KMS encryption is mandatory |
| `TestBasicRequiredOutputs` | All of `secret_arn`, `secret_id`, `secret_name`, `kms_key_id` are present in outputs |
| `TestBasicSecretResourceExists` | `aws_secretsmanager_secret.this` exists in Terraform state |
| `TestBasicIdempotency` | Re-applying produces zero changes |
| `TestBasicTerraformVersion` | Terraform version satisfies `>= 1.12.1` |

## Running

```bash
# From the module root
make test-basic

# Or via Go directly
cd /path/to/secrets-manager-secret
go test ./tests/basic/... -v -timeout 30m
```
