# AWS Lambda Primitive Module

Production-grade Lambda module supporting Zip and container deployments with comprehensive security, performance, and operational features.

## Purpose

Manages AWS Lambda functions with:
- **Deployment**: Zip packages (local file or S3 object) and container images
- **Security**: KMS encryption, code signing (Zip packages only), VPC integration, dead letter queues
- **Performance**: Provisioned concurrency, ephemeral storage, event filtering
- **Observability**: X-Ray tracing, structured logging, CloudWatch integration
- **Operations**: Function URLs, aliases, layer management, event invoke configs
- **Configuration**: Static env vars, SSM Parameters, Secrets Manager, Lambda Extensions

## Zip Package Deployment Methods

**Local File** (recommended for packages <50MB):
- Use `filename` + `source_code_hash`
- Terraform uploads directly to Lambda
- Best for development and small functions

**S3 Object** (recommended for packages ≥50MB):
- Use `s3_bucket` + `s3_key` + optional `s3_object_version`
- Lambda pulls from S3 (no upload through Terraform)
- Required for packages >50MB (Lambda API limit)
- Better for CI/CD pipelines and large dependencies

## When to Use

- Deploy serverless functions with Zip or container packages
- Integrate Lambda with SQS, DynamoDB, SNS, or Kinesis event sources
- Implement blue/green deployments with aliases and traffic shifting
- Mount EFS for stateful workloads
- Enable direct HTTPS invocation via function URLs
- Manage Lambda layers for shared dependencies

## Usage

### Zip Deployment - Local File

```hcl
module "lambda" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/lambda?ref=providers/aws/primitives/lambda/v{X.Y.Z}"

  function_name = "my-function"
  description   = "Production Lambda function"
  role          = aws_iam_role.lambda.arn
  package_type  = "Zip"
  publish       = true

  # Local file deployment
  filename         = "function.zip"
  source_code_hash = filebase64sha256("function.zip")
  handler          = "index.handler"
  runtime          = "python3.12"

  timeout                        = 30
  memory_size                    = 512
  reserved_concurrent_executions = 10
  ephemeral_storage_size         = 1024

  kms_key_arn = aws_kms_key.lambda.arn

  environment = {
    variables = {
      ENV = "production"
    }
  }

  dead_letter_config = {
    target_arn = aws_sqs_queue.dlq.arn
  }

  event_source_mappings = {
    sqs = {
      event_source_arn = aws_sqs_queue.main.arn
      batch_size       = 10
      filter_criteria = {
        filters = [
          { pattern = jsonencode({ body = { type = ["order"] } }) }
        ]
      }
    }
  }

  function_urls = {
    default = {
      authorization_type = "AWS_IAM"
    }
  }

  aliases = {
    prod = {
      function_version = "1"
    }
  }
}
```

### Zip Deployment - S3 Object

```hcl
module "lambda_s3" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/lambda?ref=providers/aws/primitives/lambda/v{X.Y.Z}"

  function_name = "my-function"
  role          = aws_iam_role.lambda.arn
  package_type  = "Zip"

  # S3 object deployment (recommended for packages >50MB)
  s3_bucket         = "my-lambda-artifacts"
  s3_key            = "functions/my-function-v1.0.0.zip"
  s3_object_version = "abc123"  # Optional: for versioned buckets
  source_code_hash  = "base64-encoded-sha256"  # Optional: for change detection
  handler           = "index.handler"
  runtime           = "python3.12"

  timeout     = 30
  memory_size = 512
}
```

### Container Deployment with VPC and EFS

```hcl
module "lambda_container" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/lambda?ref=providers/aws/primitives/lambda/v{X.Y.Z}"

  function_name = "my-container-function"
  role          = aws_iam_role.lambda.arn
  package_type  = "Image"

  image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-function:latest"

  image_config = {
    command = ["app.handler"]
  }

  architectures = ["arm64"]
  timeout       = 60
  memory_size   = 2048

  vpc_config = {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda.id]
  }

  file_system_config = {
    arn              = aws_efs_access_point.lambda.arn
    local_mount_path = "/mnt/efs"
  }
}
```

### Configuration Input Methods

```hcl
# Static environment variables
environment = {
  variables = {
    LOG_LEVEL = "INFO"
  }
}

# SSM Parameters (fetched at deploy time, injected as env vars)
environment_from_ssm = {
  DB_PASSWORD = "/myapp/db/password"
  API_KEY     = "/myapp/api/key"
}

# Secrets Manager (fetched at deploy time, injected as env vars)
environment_from_secrets = {
  DB_CREDS = "arn:aws:secretsmanager:us-east-1:123456789012:secret:db-creds"
}

# Lambda Extension for runtime SSM/Secrets access (no env vars)
enable_parameters_and_secrets_extension = true
parameters_and_secrets_extension_config = {
  http_port                   = 2773
  secrets_manager_timeout     = 5000
  ssm_parameter_store_timeout = 5000
  max_connections             = 3
}
```

## Examples

- `lambda-zip-deployment/` - Zip deployment with SSM/Secrets env vars, event sources, function URLs, aliases, provisioned concurrency
- `lambda-docker-deployment/` - Container deployment with Lambda Extension, VPC, EFS, custom layers

## Documentation

See [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for complete input/output documentation.
