# Terraform Policy Libraries

## Overview
Reusable OPA policies for Terraform module validation. These libraries are imported by module type-specific policies to ensure consistent enforcement across collection, primitive, and reference modules.

## Architecture
- **Libraries** (`policies/opa/terraform/libraries/`) - Reusable policy implementations
- **Module Types** (`policies/opa/terraform/module_types/`) - Import wrappers that apply libraries to specific module types

## Policy Documentation

### Module Structure & Organization
- [File Organization Policy](docs/file_organization_policy.md) - Enforces proper file organization (variables, outputs, locals, etc.)
- [Structure Policy](docs/structure_policy.md) - Validates required files and directories
- [Structure Policy - Examples](docs/structure_policy_examples.md) - Validates example implementations
- [Nested Modules Policy](docs/nested_modules_policy.md) - Prevents nested module structures

### Module Standards
- [Makefile Policy](docs/makefile_policy.md) - Ensures Makefile matches skeleton
- [Naming Policy](docs/naming_policy.md) - Prevents dynamic resource name generation
- [Version Constraint Policy](docs/version_constraint_policy.md) - Enforces Terraform version >= 1.12.1
- [Hardcoded Values Policy](docs/hardcoded_values_policy.md) - Prevents hardcoded values (with exemptions)

### Module Dependencies
- [Source Policy](docs/source_policy.md) - Validates module sources and version constraints

### Testing Requirements
- [Tests Policy](docs/tests_policy.md) - Enforces comprehensive testing with Terratest Framework
- [Tests Helpers Policy](docs/tests_helpers_policy.md) - Validates test helper structure

## Usage Pattern
Each library policy is imported by module type wrappers:

```rego
package terraform.module_types.<type>.<policy_name>

import data.terraform.libraries.<policy_name>

violation[result] if {
	result := <policy_name>.violation[_]
}
```

## Module Type Application

| Policy | Collection | Primitive | Reference | Data | Utility |
|--------|-----------|-----------|-----------|------|---------|
| File Organization | ✓ | ✓ | ✓ | - | - |
| Makefile | ✓ | ✓ | ✓ | - | - |
| Naming | ✓ | ✓ | ✓ | - | - |
| Nested Modules | ✓ | ✓ | ✓ | - | - |
| Source | ✓ | ✓ | ✓ | - | - |
| Structure | ✓ | ✓ | ✓ | - | - |
| Structure Examples | ✓ | ✓ | ✓ | - | - |
| Tests | ✓ | ✓ | ✓ | - | - |
| Tests Helpers | ✓ | ✓ | ✓ | - | - |
| Version Constraint | ✓ | ✓ | ✓ | - | - |
| Hardcoded Values | ✓ | ✓ | ✓ | ✗ | ✗ |

**Legend:**
- ✓ Applied
- ✗ Explicitly exempted
- \- Not applicable (module type has different requirements)
