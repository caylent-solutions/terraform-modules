# Basic VPC Example

This example demonstrates the basic usage of the VPC module with minimal configuration.

## Usage

```hcl
module "vpc" {
  source = "../../"

  name       = "test-vpc"
  cidr_block = "10.0.0.0/16"
  tags = {
    Environment = "test"
    Purpose     = "vpc-module-testing"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.12.1 |
| aws | >= 5.14 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name for the VPC | `string` | n/a | yes |
| cidr_block | CIDR block for the VPC | `string` | n/a | yes |
| tags | Tags to apply to the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_arn | ARN of the VPC |
| vpc_cidr_block | CIDR block of the VPC |