# Data Sources Only Policy

## Overview
Enforces that data modules contain locals blocks in *-data.tf files for constants and output blocks in outputs.tf for exposing those constants.

## Policy Name
`terraform_module_data_sources_only_policy`

## Severity
Error

## Description
This policy ensures data modules define constants in locals blocks within *-data.tf files and expose them via outputs in outputs.tf. Data modules cannot create resources or compose other modules - they exist to provide reusable constants and optionally query existing infrastructure.

## Violations

### Resource Blocks Present
**Message:** "Data modules cannot contain resource blocks"

**Details:** Data modules should only contain data sources for querying existing resources

**Resolution:** Replace resource blocks with data source blocks or move to appropriate module type

**Example of violation:**
```hcl
# providers/aws/data/account-info/main.tf
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"
}
```

### Module Blocks Outside Examples
**Message:** "Data modules cannot contain module blocks outside examples directory"

**Details:** Data modules should contain locals blocks for constants. Module blocks are only allowed in examples directory for testing

**Resolution:** Remove module blocks from module root or move to examples directory

**Example of violation:**
```hcl
# providers/aws/data/account-info/main.tf
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
}
```

**Example of allowed usage:**
```hcl
# providers/aws/data/account-info/examples/basic/main.tf
module "account_info" {
  source = "../../"
}
```

### Missing Locals in Data Files
**Message:** "Data modules must contain locals blocks in *-data.tf files"

**Details:** Data modules should contain locals blocks for constants in files matching pattern '*-data.tf'

**Resolution:** Add locals blocks to your *-data.tf files

**Example of violation:**
```hcl
# providers/aws/data/constants/aws-data.tf
# Empty file or no locals block
data "aws_caller_identity" "current" {}
```

### No Outputs in outputs.tf
**Message:** "Data modules must contain at least one output block in outputs.tf"

**Details:** Data modules should expose constants via output blocks in outputs.tf

**Resolution:** Add at least one output block to outputs.tf

**Example of violation:**
```hcl
# providers/aws/data/constants/outputs.tf
# Empty file or no output blocks
```

## Compliant Examples

### Constants Data Module
```hcl
# providers/aws/data/constants/aws-constants-data.tf
locals {
  account_id_regex = "[0-9]{12}"
  region_codes = {
    us_east_1 = "us-east-1"
    us_west_2 = "us-west-2"
  }
}

# providers/aws/data/constants/outputs.tf
output "account_id_regex" {
  description = "AWS Account ID validation regex"
  value       = local.account_id_regex
}

output "region_codes" {
  description = "AWS region code constants"
  value       = local.region_codes
}
```

### IAM Identity Center Constants
```hcl
# providers/aws/data/iam-constants/iam-identity-center-data.tf
data "aws_ssoadmin_instances" "current" {}

locals {
  principal_types = {
    group = "GROUP"
    user  = "USER"
  }
  provider_types = {
    internal = "INTERNAL"
    external = "EXTERNAL"
  }
}

# providers/aws/data/iam-constants/outputs.tf
output "principal_types" {
  description = "IAM Identity Center principal types"
  value       = local.principal_types
}

output "provider_types" {
  description = "IAM Identity Center provider types"
  value       = local.provider_types
}
```

## Use Cases
Data modules are ideal for:
- Defining reusable constants (regex patterns, service limits, API values)
- Providing standardized naming conventions
- Exposing AWS service constants and configuration values
- Optionally validating constants against live AWS services via data sources
- Creating centralized constant libraries for other modules

## Module Types Using This Policy
- Data modules

## Related Policies
- `no_resources_policy.rego` - Similar but doesn't require data sources
- `composition_policy.rego` - Prohibits resources but requires modules
