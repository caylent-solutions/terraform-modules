# Basic Example - AWS Constants Data Module

This example demonstrates how to use the AWS Constants data module to access centralized AWS service constants.

## Usage

```hcl
module "aws_constants" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/data/aws-constants?ref=providers/aws/data/aws-constants/v1.0.0"
}

# Access IAM Identity Center constants
output "sso_constants" {
  value = module.aws_constants.iam_identity_center
}

# Access general AWS constants
output "general_constants" {
  value = module.aws_constants.general
}
```

## What This Example Does

- Instantiates the AWS Constants data module
- Exposes all available constants through outputs
- Demonstrates how to access specific constant categories

## Requirements

- AWS CLI configured with valid credentials
- Terraform >= 1.0
- AWS Provider >= 5.0

## Running This Example

```bash
terraform init
terraform plan
terraform apply
```

## Outputs

This example outputs all available constants organized by category:

- `iam_identity_center_constants` - IAM Identity Center specific constants
- `general_constants` - General AWS constants
- `all_constants` - Combined view of all constants

## Account Requirements

This example works in any AWS account and does not require:
- Organization management account access
- SSO configuration
- Resource creation permissions
- Special IAM permissions beyond basic AWS API access