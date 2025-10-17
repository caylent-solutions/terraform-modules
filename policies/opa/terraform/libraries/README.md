# Terraform Policy Libraries

## Overview
Reusable OPA policies for Terraform module validation. These libraries are imported by module type-specific policies to ensure consistent enforcement across collection, primitive, and reference modules.

## Architecture
- **Libraries** (`policies/opa/terraform/libraries/`) - Reusable policy implementations
- **Module Types** (`policies/opa/terraform/module_types/`) - Import wrappers that apply libraries to specific module types

## Policy Documentation

### Module Structure & Organization
- [File Organization Policy](docs/file_organization_policy.md) - Enforces proper file organization (variables, outputs, locals, etc.)
- [Data File Organization Policy](docs/data_file_organization_policy.md) - Enforces file organization for data modules (optional files)
- [Structure Policy](docs/structure_policy.md) - Validates required files and directories
- [Data Structure Policy](docs/data_structure_policy.md) - Validates required files and directories for data modules
- [Structure Policy - Examples](docs/structure_policy_examples.md) - Validates example implementations
- [Nested Modules Policy](docs/nested_modules_policy.md) - Prevents nested module structures

### Module Standards
- [Makefile Policy](docs/makefile_policy.md) - Ensures Makefile matches skeleton
- [Naming Policy](docs/naming_policy.md) - Prevents dynamic resource name generation
- [Version Constraint Policy](docs/version_constraint_policy.md) - Enforces Terraform version >= 1.12.1
- [Hardcoded Values Policy](docs/hardcoded_values_policy.md) - Prevents hardcoded values (with exemptions)

### Module Dependencies
- [Source Policy](docs/source_policy.md) - Validates module sources and version constraints
- [Composition Policy](docs/composition_policy.md) - Enforces composition module rules (no resources, requires modules)
- [No Resources Policy](docs/no_resources_policy.md) - Prevents resource blocks in non-resource modules

### Cloud Provider Restrictions
- [AWS Only Provider Restriction Policy](docs/aws_only_provider_restriction_policy.md) - Enforces AWS-only cloud provider usage
- [GitHub Only Provider Restriction Policy](docs/github_only_provider_restriction_policy.md) - Enforces GitHub-only cloud provider usage

### Module Content Restrictions
- [Data Sources Only Policy](docs/data_sources_only_policy.md) - Enforces data-only modules (no resources or modules)

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
| Data File Organization | - | - | - | ✓ | - |
| Makefile | ✓ | ✓ | ✓ | - | - |
| Naming | ✓ | ✓ | ✓ | - | - |
| Nested Modules | ✓ | ✓ | ✓ | - | - |
| Source | ✓ | ✓ | ✓ | - | - |
| Structure | ✓ | ✓ | ✓ | - | - |
| Data Structure | - | - | - | ✓ | - |
| Structure Examples | ✓ | ✓ | ✓ | ✓ | - |
| Tests | ✓ | ✓ | ✓ | - | - |
| Tests Helpers | ✓ | ✓ | ✓ | - | - |
| Version Constraint | ✓ | ✓ | ✓ | - | - |
| Hardcoded Values | ✓ | ✓ | ✓ | ✗ | ✗ |
| Composition | ✓ | - | ✓ | - | - |
| No Resources | - | - | - | ✓ | ✓ |
| Data Sources Only | - | - | - | ✓ | - |
| Data File Organization | - | - | - | ✓ | - |
| AWS Only | ✓ | ✓ | ✓ | ✓ | ✓ |

**Legend:**
- ✓ Applied
- ✗ Explicitly exempted
- \- Not applicable (module type has different requirements)
