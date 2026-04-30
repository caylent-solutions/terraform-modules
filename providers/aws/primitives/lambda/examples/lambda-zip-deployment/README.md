# Lambda Zip Deployment Example

Comprehensive example demonstrating Zip-based Lambda deployment with **S3 artifact storage** and all production features.

## Deployment Method

This example uses **S3 object deployment**:
1. Terraform creates zip file locally using `archive_file` data source
2. Uploads zip to S3 bucket
3. Lambda pulls deployment package from S3

This method is recommended for:
- Packages ≥50MB (required for >50MB due to Lambda API limits)
- CI/CD pipelines with artifact storage
- Better version control and artifact management

## Features Demonstrated

- **Deployment**: S3-based Zip package with Python 3.12
- **Configuration**: Static env vars, SSM Parameters, Secrets Manager (all as env vars)
- **Security**: KMS encryption for environment variables, dead letter queue
- **Performance**: Provisioned concurrency, ephemeral storage (1GB), event filtering
- **Observability**: JSON logging, X-Ray tracing
- **Integration**: SQS event source with filtering, SNS success/failure destinations
- **Operations**: Function URL with CORS, alias for blue/green, event invoke config

## Resources Created

- **S3 bucket** for Lambda artifacts
- **S3 object** containing the deployment package
- Lambda function with S3-based Zip deployment
- SQS queue for event source
- SQS dead letter queue
- SNS topics for success/failure notifications
- KMS key for environment variable encryption
- CloudWatch log group
- Function URL with public access
- Lambda alias (prod)
- Provisioned concurrency configuration
- SSM Parameter and Secrets Manager secret (with random suffix for uniqueness)
- IAM role and policies for Lambda execution

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Notes

- Resource names include a random suffix to prevent collisions across test runs
- Secrets Manager secrets use `recovery_window_in_days = 0` for immediate deletion
- Maximum concurrency is set to 5 (must be ≤ reserved concurrent executions)
- All environment variables must be strings (Secrets Manager values are not decoded)

## Inputs

See [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for detailed inputs.

## Outputs

- `function_arn` - Lambda function ARN
- `function_url` - Direct HTTPS invocation URL
- `alias_arn` - Production alias ARN
- `event_source_mapping_uuid` - SQS event source mapping ID

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md) for the complete list of outputs.
