# Lambda Docker Deployment Example

Container-based Lambda deployment with VPC, EFS, and custom layers.

**⚠️ Warning:** This example takes 30+ minutes to deploy and destroy due to VPC ENI cleanup. Recommended for manual testing only, not CI/CD pipelines.

## Features Demonstrated

- **Deployment**: Container image from ECR with ARM64 architecture
- **Configuration**: Lambda Extension for runtime SSM/Secrets access (no env vars)
- **Security**: VPC integration (code signing not supported for container images)
- **Storage**: EFS file system mount for stateful workloads
- **Performance**: 2GB memory, 2GB ephemeral storage
- **Extensibility**: Custom Lambda layer creation
- **Operations**: Lifecycle management with create_before_destroy

## Resources Created

- Lambda function with container deployment (ARM64 architecture)
- ECR repository for image storage
- Docker image automatically built and pushed to ECR via null_resource provisioner
- VPC with 2 subnets across availability zones
- Security group for Lambda
- EFS file system with mount targets and access point
- Custom Lambda layer from local files
- SSM Parameter and Secrets Manager secret (with random suffix for uniqueness)
- IAM role and policies for Lambda execution with VPC and extension permissions

## Usage

```bash
# Docker image is automatically built and pushed during terraform apply
terraform init
terraform plan
terraform apply
```

## Notes

- **Deployment time**: 25-30 minutes due to VPC, EFS, and Docker image build
- **Destroy time**: 45+ minutes due to Lambda-managed ENI cleanup (AWS controlled)
- Docker image is built from AWS Lambda Python 3.12 base image and pushed to ECR automatically
- Resource names include a random suffix to prevent collisions
- Code signing is NOT supported for container images (commented out in example)
- VPC ENIs are managed by AWS Lambda service and cannot be manually deleted
- Idempotency testing is disabled due to long execution times

## Inputs

See [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for detailed inputs.

## Outputs

- `function_arn` - Lambda function ARN
- `layer_version_arn` - Custom layer ARN
- `efs_file_system_id` - EFS file system ID
- `ecr_repository_url` - ECR repository URL for the container image
