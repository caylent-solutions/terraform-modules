# Data Sources Only Policy

## Overview
Enforces that data modules only contain data source blocks for querying existing AWS resources and constants.

## Policy Name
`terraform_module_data_sources_only_policy`

## Severity
Error

## Description
This policy ensures data modules are read-only and only query existing infrastructure. Data modules cannot create resources or compose other modules - they exist solely to fetch information about what already exists in AWS.

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

### Module Blocks Present
**Message:** "Data modules cannot contain module blocks"

**Details:** Data modules should only contain data sources for querying existing resources

**Resolution:** Remove module blocks or move to collection module type

**Example of violation:**
```hcl
# providers/aws/data/account-info/main.tf
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
}
```

### No Data Sources
**Message:** "Data modules must contain at least one data source"

**Details:** Data modules should contain data sources for querying existing resources

**Resolution:** Add at least one data source to your data module

**Example of violation:**
```hcl
# providers/aws/data/account-info/main.tf
locals {
  account_id = "123456789012"
}
```

## Compliant Examples

### Account Information Data Module
```hcl
# providers/aws/data/account-info/main.tf
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}
```

### VPC Lookup Data Module
```hcl
# providers/aws/data/vpc-lookup/main.tf
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}
```

### AMI Lookup Data Module
```hcl
# providers/aws/data/ami-lookup/main.tf
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
```

## Use Cases
Data modules are ideal for:
- Querying AWS account information (account ID, region, availability zones)
- Looking up existing VPCs, subnets, security groups
- Finding AMI IDs based on filters
- Retrieving SSM parameters
- Getting AWS service constants and limits
- Fetching existing resource attributes by tags or filters

## Module Types Using This Policy
- Data modules

## Related Policies
- `no_resources_policy.rego` - Similar but doesn't require data sources
- `composition_policy.rego` - Prohibits resources but requires modules
