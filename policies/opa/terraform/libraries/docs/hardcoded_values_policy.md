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
- **Resolution:** Replace hardcoded values with variables or data sources

## Rationale
Hardcoded values reduce module reusability and make it difficult to use modules across different environments or accounts.

## Exemptions
This policy is NOT applied to:
- **Data modules** - May contain hardcoded values for querying specific resources
- **Utility modules** - May contain hardcoded constants for reusable logic

## Applied To
- Collection modules
- Primitive modules
- Reference modules
