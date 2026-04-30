# Basic Example Tests

Asserts:

- `SecretExists` -- ARN, name, version id, and KMS ARN are populated
- `DescribeSecretMatchesInputs` -- AWS-side KmsKeyId matches the test CMK ARN; name matches
- `InitialSecretValueRetrievable` -- `GetSecretValue` returns the JSON `{username,password}` payload with the expected fields

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/secrets-manager-secret
```
