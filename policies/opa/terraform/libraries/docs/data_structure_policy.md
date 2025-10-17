# Data Structure Policy

## Overview

The data structure policy enforces standardized file and directory structure for data-only Terraform modules. Data modules retrieve and expose existing infrastructure information without creating resources.

## Rules

### 1. Required Root Files

**Rule:** Data module root must contain specific required files.

**Required files:**
- `README.md` - Module documentation
- `TERRAFORM-DOCS.md` - Auto-generated Terraform documentation
- `CODEOWNERS` - Code ownership definition
- `Makefile` - Build and test automation
- `outputs.tf` - Module outputs

**Rationale:** Ensures consistent documentation, ownership, and automation across all data modules.

**Example Violation:**
```
module/
├── s3-data.tf
# ❌ Missing README.md, TERRAFORM-DOCS.md, CODEOWNERS, Makefile, outputs.tf
```

**Example Compliance:**
```
module/
├── s3-data.tf
├── outputs.tf
├── README.md
├── TERRAFORM-DOCS.md
├── CODEOWNERS
└── Makefile
```

---

### 2. At Least One *-data.tf File Required

**Rule:** Module must contain at least one file matching the pattern `*-data.tf`.

**Pattern:** `<name>-data.tf` where `<name>` contains only letters and numbers (no spaces or special characters).

**Valid examples:**
- `s3-data.tf`
- `ec2-data.tf`
- `vpc-data.tf`
- `rds123-data.tf`

**Invalid examples:**
- `data.tf` (doesn't match pattern)
- `s3_data.tf` (underscore not allowed)
- `s3 data.tf` (space not allowed)

**Rationale:** Data modules must contain data sources. The naming pattern clearly identifies data retrieval files.

---

### 3. Required Files Cannot Be Empty

**Rule:** Required files must have content.

**Non-empty files:**
- `README.md`
- `TERRAFORM-DOCS.md`
- `CODEOWNERS`
- `Makefile`
- `outputs.tf`

**Rationale:** Empty files don't serve their purpose. Each file must have meaningful content.

---

### 4. Data Files Cannot Be Empty

**Rule:** All `*-data.tf` files must have content.

**Triggers when:** Any file matching the `*-data.tf` pattern is empty or contains only whitespace.

**Rationale:** Data files must contain actual data sources, not be empty placeholders.

**Example Violation:**
```hcl
# s3-data.tf
# ❌ Empty file
```

**Example Compliance:**
```hcl
# s3-data.tf
data "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}
```

---

### 5. Only Allowed .tf Files in Root

**Rule:** Only specific `.tf` files are permitted in the module root.

**Allowed .tf files:**
- `main.tf` - Main configuration
- `variables.tf` - Input variables
- `versions.tf` - Terraform and provider versions
- `outputs.tf` - Module outputs
- `locals.tf` - Local values
- `*-data.tf` - Data source files (one or more)

**Disallowed files:**
- `resources.tf`
- `data.tf`
- Any other `.tf` files not matching the allowed patterns

**Rationale:** Enforces standardized file naming for data modules.

**Example Violation:**
```
module/
├── s3-data.tf
├── resources.tf   # ❌ Not allowed
└── outputs.tf
```

**Example Compliance:**
```
module/
├── s3-data.tf     # ✅ Matches *-data.tf pattern
├── ec2-data.tf    # ✅ Multiple data files allowed
├── main.tf        # ✅ Allowed
├── variables.tf   # ✅ Allowed
├── versions.tf    # ✅ Allowed
├── outputs.tf     # ✅ Allowed
└── locals.tf      # ✅ Allowed
```

---

### 6. Examples Directory Required

**Rule:** Module must have an `examples/` directory.

**Rationale:** Every module needs example implementations for documentation and testing.

---

### 7. Tests Directory Required

**Rule:** Module must have a `tests/` directory.

**Rationale:** All modules require comprehensive tests using the Terratest framework.

## Policy Details

- **Package:** `terraform.libraries.data_structure`
- **Policy Name:** `terraform_module_data_structure_policy`
- **Severity:** `error`

## Usage

This policy is imported by data module type-specific policies:

```rego
package terraform.provider.aws.module_types.data

import data.terraform.libraries.data_structure

violation := data_structure.violation
```

## Testing

Test this policy using the Rego unit test framework:

```bash
make rego-unit-test
```

## Related Policies

- [Structure Policy](structure_policy.md) - Standard module structure (for non-data modules)
- [Data File Organization Policy](data_file_organization_policy.md) - File organization rules for data modules
- [Data Sources Only Policy](data_sources_only_policy.md) - Enforces data sources only
- [No Resources Policy](no_resources_policy.md) - Prevents resource blocks
