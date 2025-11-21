# Cross-Account SNS Topic Example

This example demonstrates how to configure an SNS topic with cross-account access permissions.

## Features

- Custom policy allowing specific external AWS accounts
- Service principal access (e.g., S3, CloudWatch)
- Secure cross-account publishing pattern
- KMS encryption

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Cross-Account Access Pattern

This example shows how to:
- Allow specific AWS accounts to publish to the topic
- Grant service principals (like S3) permission to publish
- Maintain security while enabling cross-account integration

## Security Considerations

- Only explicitly allowed accounts can publish
- Service principals are scoped to specific resources
- KMS encryption is enabled for data protection
