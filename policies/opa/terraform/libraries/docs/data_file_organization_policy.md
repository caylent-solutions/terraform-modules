# Data File Organization Policy

## Overview
Enforces file organization rules for data modules with optional file requirements - files are only required if their corresponding blocks exist.

## Policy Name
`terraform_data_file_organization_policy`

## Severity
Error

## Description
This policy ensures proper file organization in data modules. Unlike standard modules, data modules don't require specific files to exist. However, if certain block types are present, they must be in their designated files.

## Violations

### Variables in Wrong File
**Message:** "Variable declarations must be in variables.tf"

**Condition:** IF variable blocks exist, they must only be in `variables.tf`

**Example of violation:**
```hcl
# main.tf
variable "vpc_name" {
  type = string
}
```

### Outputs in Wrong File
**Message:** "Output declarations must be in outputs.tf"

**Condition:** IF output blocks exist, they must only be in `outputs.tf`

**Example of violation:**
```hcl
# main.tf
output "vpc_id" {
  value = data.aws_vpc.selected.id
}
```

### Terraform Blocks in Wrong File
**Message:** "Terraform blocks must be in versions.tf"

**Condition:** IF terraform blocks exist, they must only be in `versions.tf`

**Example of violation:**
```hcl
# main.tf
terraform {
  required_version = ">= 1.0"
}
```

### Required Providers in Wrong File
**Message:** "Required providers blocks must be in versions.tf"

**Condition:** IF required_providers blocks exist, they must only be in `versions.tf`

**Example of violation:**
```hcl
# main.tf
required_providers {
  aws = {
    source = "hashicorp/aws"
  }
}
```

### Locals in Wrong File
**Message:** "Locals blocks must be in locals.tf or *-data.tf files"

**Condition:** IF locals blocks exist, they must only be in `locals.tf` or files matching pattern `*-data.tf`

**Example of violation:**
```hcl
# main.tf
locals {
  region = "us-east-1"
}
```

**Example of compliant usage:**
```hcl
# locals.tf
locals {
  region = "us-east-1"
}

# OR in data files:
# aws-constants-data.tf
locals {
  account_id_regex = "[0-9]{12}"
}
```

## Compliant Examples

### Minimal Data Module (Only main.tf)
```hcl
# main.tf
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
```
✅ No violations - no special files required

### Data Module with Outputs
```hcl
# main.tf
data "aws_caller_identity" "current" {}

# outputs.tf
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
✅ Outputs properly organized in outputs.tf

### Data Module with Variables and Locals
```hcl
# main.tf
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# variables.tf
variable "vpc_name" {
  type = string
}

# locals.tf
locals {
  vpc_id = data.aws_vpc.selected.id
}

# OR for data modules with constants:
# aws-constants-data.tf
locals {
  region_codes = {
    us_east_1 = "us-east-1"
    us_west_2 = "us-west-2"
  }
}

# outputs.tf
output "vpc_id" {
  value = local.vpc_id
}
```
✅ All blocks properly organized

## Key Differences from Standard File Organization Policy
- **No required files**: Files only need to exist if their corresponding blocks are present
- **Flexible structure**: Data modules can be as simple as a single `main.tf` with data sources
- **Same organization rules**: When blocks exist, they must follow the same organization as other module types

## Module Types Using This Policy
- Data modules

## Related Policies
- `file_organization_policy.rego` - Standard file organization (requires specific files)
- `data_sources_only_policy.rego` - Enforces data-only content
