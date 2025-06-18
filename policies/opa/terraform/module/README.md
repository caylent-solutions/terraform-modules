# Terraform Module Policies

This directory contains OPA policies for validating Terraform modules.

## Policies

### file_organization_policy.rego
Ensures that variable declarations are in variables.tf, output declarations are in outputs.tf, etc.

### hardcoded_values_policy.rego
Checks for hardcoded values that should be variables.

### makefile_policy.rego
Validates that the module's Makefile matches the skeleton Makefile.

### naming_policy.rego
Enforces naming conventions for resources, variables, etc.

### nested_modules_policy.rego
Ensures that Terraform modules don't have nested modules (except in examples and tests directories).

### single_module_policy.rego
Validates that a PR changes only one Terraform module at a time.

### source_policy.rego
Checks that module sources are properly specified with appropriate version constraints.

### structure_policy.rego
Ensures that modules have the required files and directories.

### structure_policy_examples.rego
Validates the structure of example directories.

### tests_helpers_policy.rego
Validates the structure of test helper files.

### tests_policy.rego
Ensures that modules have proper test files.

### version_constraint_policy.rego
Validates that modules specify the correct Terraform version constraint (>= 1.12.1).