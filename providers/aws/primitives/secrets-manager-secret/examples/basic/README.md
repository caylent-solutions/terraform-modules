# secrets-manager-secret / basic example

Provisions a customer-managed KMS key + a Secrets Manager secret encrypted with that key, populated with a JSON `{username, password}` payload, and configured with a 90-day rotation cadence (no rotation Lambda attached in this example).

## What it creates

- `aws_kms_key.secret` -- test CMK with rotation enabled
- `module.secret` -- the `secrets-manager-secret` primitive, configured with:
  - Customer-managed KMS key
  - `recovery_window_in_days = 0` (immediate delete on destroy)
  - JSON-encoded initial secret value
  - 90-day rotation cadence (no Lambda)

## Apply

```bash
cd providers/aws/primitives/secrets-manager-secret/examples/basic
terraform init
terraform apply -auto-approve
```

## Outputs

- `secret_arn`, `secret_name`, `secret_version_id`, `kms_key_arn`
