# Terraform Module Policies

This document outlines the policies enforced for all Terraform modules in this repository.

## Module Structure Policies

### File Organization

1. **Variable Declarations**
   - All variable declarations must be in `variables.tf`
   - No variable declarations are allowed in other files

2. **Output Declarations**
   - All output declarations must be in `outputs.tf`
   - No output declarations are allowed in other files

3. **Terraform and Provider Configuration**
   - All `terraform` blocks must be in `versions.tf`
   - All `required_providers` blocks must be in `versions.tf`
   - No terraform or provider configuration is allowed in other files

4. **Local Variables**
   - All `locals` blocks must be in `locals.tf`
   - No locals blocks are allowed in other files

### Required Files and Directories

1. **Root Directory Files**
   - `main.tf` (required, non-empty)
   - `variables.tf` (required, non-empty)
   - `outputs.tf` (required, can be empty)
   - `versions.tf` (required, non-empty)
   - `locals.tf` (required, can be empty)
   - `README.md` (required, non-empty)
   - `TERRAFORM-DOCS.md` (required, non-empty)
   - `CODEOWNERS` (required, non-empty)
   - `Makefile` (required, must match skeleton)
   - `test.config` (required, must include TERRATEST_IDEMPOTENCY setting)

2. **Examples Directory**
   - At least one example directory is required
   - Each example must contain:
     - `main.tf` (non-empty)
     - `variables.tf` (non-empty)
     - `versions.tf` (non-empty)
     - `terraform.tfvars` (non-empty)
     - `README.md` (non-empty)
     - `TERRAFORM-DOCS.md` (non-empty)

3. **Tests Directory**
   - For each example directory, there must be a corresponding test directory with the same name
   - If there are multiple examples, a `common` test directory is also required
   - Each test directory must contain:
     - `module_test.go` (non-empty)
     - `README.md` (non-empty)
   - The tests directory must have a `README.md` (non-empty)
   - Optional `helpers` directory, if present must contain:
     - `helpers.go` (non-empty)
     - `README.md` (non-empty)

### Code Quality Policies

1. **No Hard-coded Values**
   - All values in Terraform code must use variables
   - No hard-coded strings, numbers, booleans, JSON objects, or YAML heredocs
   - Hard-coded values are only permitted in:
     - `terraform.tfvars` files
     - Default values in `variables.tf`
   - Hard-coded values are not allowed in any other files or blocks

2. **No Nested Modules**
   - Terraform modules cannot contain nested modules
   - All `.tf` files must be in the root directory (except in examples and tests)

3. **Limited .tf Files**
   - Only `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, and `locals.tf` are allowed in the root directory

4. **Resource Naming**
   - Resource names cannot be dynamically generated
   - Resource names must come from variables or variable defaults
   - No interpolation or functions are allowed in resource names

5. **Module Sources**
   - No local module sources are allowed (no relative or absolute paths)
   - All module sources must have version constraints
   - External module sources (non-Caylent) must use pinned version constraints (exact version)
   - Caylent module sources may use fuzzy version constraints for minor and patch updates

### Testing Policies

1. **Required Test Structure**
   - Each example must have a corresponding test directory with the same name
   - A `common` test directory is required if there are multiple examples
   - Each test directory must contain a `module_test.go` file and a `README.md` file
   - The tests directory must have a `README.md` file

2. **Framework Usage**
   - All tests must use the Terraform Terratest Framework
   - Test files must import the framework packages
   - The module must have a `go.mod` file with the framework dependency

3. **Test Content**
   - All test files must not be empty
   - Test files must import the terraform-terratest-framework
   - Tests must verify the module's core functionality
   - Common tests must include validation, formatting, and output verification
   - Example-specific tests must verify the unique features of each example

4. **Policy Integration Tests**
   - The repository includes a non-compliant module that fails all policies
   - Integration tests verify that compliant modules pass all policies
   - Integration tests verify that non-compliant modules fail all policies
   - Run with `make rego-integration-test`

### Version and Provider Policies

1. **Terraform Version Constraint**
   - All modules must specify `required_version = ">= 1.12.1"` in `versions.tf`
   - The `versions.tf` file is required in all modules

2. **Provider Restrictions**
   - Only AWS is allowed among major cloud providers (Azure, GCP)
   - Disallowed providers include: `azurerm`, `google`, `google-beta`, `azuread`
   - Other non-cloud providers (GitHub, SumoLogic, etc.) are permitted

## License Policy

1. **Single License**
   - Only the Apache 2.0 license at the repository root is allowed
   - No additional LICENSE files may be added anywhere in the repository
   - No license statements may be added to any files

## Makefile Policy

1. **Standard Makefile**
   - The Makefile must match the content of the skeleton Makefile
   - No modifications to the Makefile are allowed