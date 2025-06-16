# Module Validator Script

This document describes the script used to validate Terraform modules against type-specific policies in the monorepo.

## Overview

The `module-validator` script evaluates a Terraform module against a set of Open Policy Agent (OPA) policies specific to its module type. This ensures that each module adheres to the structural and content requirements defined for its type.

## Features

- Validates modules against type-specific policies
- Collects all Terraform files in a module for analysis
- Provides detailed error messages for policy violations
- Uses color-coded output for better readability
- Integrates with the monorepo's configuration system

## Usage

The script is primarily used in CI/CD pipelines to validate modules:

```bash
go run scripts/module-validator/main.go --module-path providers/aws/primitives/s3-bucket --module-type primitive --config monorepo-config.json
```

## Command Line Options

- `--module-path`: Path to the Terraform module (required)
- `--module-type`: Type of the Terraform module (required)
- `--config`: Path to the monorepo configuration file (required)

## Configuration

The script uses the following sections from the `monorepo-config.json` file:

- `scripts.terraform_file_collector`: Path to the Terraform file collector script
- `scripts.temp_file_pattern`: Pattern for temporary files
- `module_types.<type>.policy_dir`: Directory containing OPA policies for the module type

## Policy Evaluation

The script evaluates the module against all `.rego` files in the policy directory for the specified module type. Each policy can define violations with the following structure:

```rego
violation[result] {
  # Policy logic
  result := {
    "message": "Human-readable error message",
    "details": "Technical details about the violation",
    "resolution": "Steps to resolve the violation"
  }
}
```

## Output

The script produces detailed output about policy violations:

```
=== Evaluating module type policies for primitive module ===
Evaluating policy: required_files.rego
✓ No violations in required_files.rego
Evaluating policy: required_examples.rego
✗ Policy violations found in required_examples.rego
  Missing required example files
  Details: Module must contain at least one example in the examples directory
  Resolution: Create at least one example in the examples directory

=== Module type policy check failed ===
```

## Error Handling

The script exits with a non-zero status code in the following cases:

1. Required command line arguments are missing
2. The configuration file cannot be read or parsed
3. The Terraform file collector fails
4. Any policy violations are detected

Each error is clearly reported with details and resolution steps.

## Implementation Details

The script works by:

1. Loading the monorepo configuration
2. Creating a temporary file to store Terraform file data
3. Running the Terraform file collector to gather all `.tf` files in the module
4. Determining the policy directory for the specified module type
5. Running OPA evaluation for each policy file
6. Reporting any violations
7. Exiting with the appropriate status code

### Terraform File Collection

The script uses a separate `terraform-file-collector` script to gather all `.tf` files in the module. This creates a JSON structure containing the file paths and contents, which is then used as input for OPA policy evaluation.

## Integration with CI/CD

This script is typically used in the PR validation workflow after detecting that a PR contains module changes and determining the module type. It ensures that the module adheres to the structural and content requirements defined for its type.