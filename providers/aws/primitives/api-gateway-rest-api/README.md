# AWS API Gateway REST API Terraform Module

A Terraform primitive module for creating and managing AWS API Gateway Regional REST APIs with
deployment stages, method settings, CloudWatch logging, custom domain support, WAF association,
and usage plans.

## Overview

This module provisions an AWS API Gateway REST API with:

- **Regional REST API**: Configurable endpoint type (EDGE, REGIONAL, PRIVATE)
- **Deployment and Stage**: Managed deployment with configurable stage variables and settings
- **Method Settings**: Default method settings for logging, metrics, data tracing, and throttling
- **CloudWatch Logging**: Optional execution and access logging via CloudWatch
- **Custom Domain Support**: Optional custom domain name with base path mapping
- **WAF Integration**: Optional WAFv2 Web ACL association with the stage
- **Usage Plans**: Optional usage plan with quota and throttle settings

## Quick Start

### Basic Regional REST API

```hcl
resource "aws_cloudwatch_log_group" "api_access_logs" {
  name              = "/aws/apigateway/telemetry-api/v1"
  retention_in_days = 30
}

module "api_gateway_rest_api" {
  source = "git::ssh://git@github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/api-gateway-rest-api?ref=providers/aws/primitives/api-gateway-rest-api/v{X.Y.Z}"

  name       = "telemetry-api"
  stage_name = "v1"

  access_log_destination_arn = aws_cloudwatch_log_group.api_access_logs.arn

  tags = {
    Environment = "production"
    Project     = "telemetry-platform"
  }
}
```

### REST API with CloudWatch Logging

```hcl
resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/telemetry-api/v1"
  retention_in_days = 30
}

resource "aws_iam_role" "apigw_cloudwatch" {
  name = "apigw-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "apigateway.amazonaws.com" }
    }]
  })
}

module "api_gateway_rest_api" {
  source = "git::ssh://git@github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/api-gateway-rest-api?ref=providers/aws/primitives/api-gateway-rest-api/v{X.Y.Z}"

  name       = "telemetry-api"
  stage_name = "v1"

  cloudwatch_logs_role_arn   = aws_iam_role.apigw_cloudwatch.arn
  access_log_destination_arn = aws_cloudwatch_log_group.api_logs.arn
  logging_level              = "INFO"
  metrics_enabled            = true

  tags = {
    Environment = "production"
  }
}
```

## Module Structure

```
api-gateway-rest-api/
├── examples/
│   └── basic/          # Minimal Regional REST API with default settings
├── tests/
│   └── basic/          # Terratest suite for the basic example
├── main.tf             # AWS resources: REST API, deployment, stage, method settings
├── variables.tf        # All input variables
├── outputs.tf          # Module outputs
├── versions.tf         # Terraform version and provider requirements
└── locals.tf           # Common tags and derived values
```

## Configuration Reference

Refer to [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for the full auto-generated reference of all inputs and outputs.

## Running Tests

```bash
# Configure CPM automation packages
make cpm-configure

# Install Go dependencies
make install

# Run Terratest suite
make test

# Lint and format checks
make go-lint
make go-format
make tf-lint
make tf-format
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.12.1 |
| aws | ~> 6.0.0 |
