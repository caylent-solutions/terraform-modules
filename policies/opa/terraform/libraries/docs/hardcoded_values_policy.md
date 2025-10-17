# Hardcoded Values Policy

## Overview
Prevents hardcoded values in Terraform code to ensure flexibility and reusability.

## Violations

### Hardcoded Values Detected
- **Severity:** Error
- **Rule:** Terraform code should not contain hardcoded values
- **Common Examples:**
  - Hardcoded IP addresses
  - Hardcoded resource names
  - Hardcoded account IDs
  - Hardcoded region names
  - Hardcoded string literals in resource attributes
  - Hardcoded numeric values
  - Hardcoded boolean values (except in lifecycle blocks)
- **Resolution:** Replace hardcoded values with variables or data sources

## Allowed Hardcoded Values
The following hardcoded values are explicitly allowed:
- Module `source` attributes (e.g., `source = "../../data/aws-constants"`)
- Module `version` attributes (e.g., `version = "1.0.0"`)
- Lifecycle block attributes (e.g., `create_before_destroy = true`)

## Rationale
Hardcoded values reduce module reusability and make it difficult to use modules across different environments or accounts.

## Exemptions
This policy is NOT applied to:
- **Data modules** - May contain hardcoded values for querying specific resources
- **Utility modules** - May contain hardcoded constants for reusable logic
- **Module source attributes** - Module `source` attributes may contain hardcoded paths for local modules
- **Module version attributes** - Module `version` attributes may contain hardcoded version strings
- **Lifecycle blocks** - `create_before_destroy` and similar lifecycle attributes may contain hardcoded boolean values

## Applied To
- Collection modules
- Primitive modules
- Reference modules
