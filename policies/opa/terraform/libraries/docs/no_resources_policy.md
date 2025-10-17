# No Resources Policy

## Overview
Enforces that certain module types do not contain Terraform resource blocks.

## Policy Name
`terraform_module_no_resources_policy`

## Severity
Error

## Description
This policy ensures that modules designated as non-resource modules (such as utility modules) do not define any Terraform resources. These modules should only contain reusable code like locals, variables, data sources, and outputs.

## Violations

### Resource Blocks Present
**Message:** "Module cannot contain resource blocks"

**Details:** This module type should not define direct resources

**Resolution:** Remove resource blocks from this module

**Example of violation:**
```hcl
# utilities/naming/main.tf
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"
}

locals {
  name_prefix = "app"
}
```

## Compliant Examples

### Utility Module with Locals Only
```hcl
# utilities/naming/main.tf
locals {
  name_prefix = var.environment
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

### Utility Module with Data Sources
```hcl
# utilities/account-info/main.tf
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}
```

## Module Types Using This Policy
- Utility modules

## Related Policies
- `composition_policy.rego` - Similar check but also requires module sources
