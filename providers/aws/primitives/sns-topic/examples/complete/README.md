# Complete SNS Topic Example

This example demonstrates a comprehensive SNS topic configuration with all available features (non-FIFO).

## Features

- Custom KMS encryption key
- Custom topic policy
- Delivery status logging for all protocols
- Display name
- Signature version 2
- Active tracing for AWS X-Ray
- Comprehensive tagging

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Features Demonstrated

### Security
- KMS encryption with AWS managed key
- Custom policy configuration

### Observability
- Delivery status logging enabled
- Active tracing for distributed tracing
- CloudWatch integration via delivery status

### Configuration
- Display name for human-readable identification
- Signature version 2 for enhanced security
