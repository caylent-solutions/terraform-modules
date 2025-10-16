# Structure Policy - Examples

## Overview
Validates structure and content of example implementations.

## Violations

### No Example Implementations Found
- **Severity:** Error
- **Rule:** `examples/` directory must contain at least one subdirectory
- **Resolution:** Create at least one example implementation subdirectory

### Missing Required File in Example
- **Severity:** Error
- **Required Files per Example:**
  - `main.tf`
  - `terraform.tfvars`
  - `versions.tf`
  - `variables.tf`
  - `README.md`
  - `TERRAFORM-DOCS.md`
- **Resolution:** Create missing file in example directory

### Empty Required File in Example
- **Severity:** Error
- **Rule:** Required example files cannot be empty
- **Resolution:** Add content to the file

## Purpose
Ensures examples are complete, functional, and properly documented for module consumers.

## Structure
```
examples/
├── example-1/
│   ├── main.tf
│   ├── terraform.tfvars
│   ├── versions.tf
│   ├── variables.tf
│   ├── README.md
│   └── TERRAFORM-DOCS.md
└── example-2/
    └── ...
```
