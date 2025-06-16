# Terraform File Collector Script

This document describes the script used to collect and process Terraform files for policy evaluation in the monorepo.

## Overview

The `terraform-file-collector` script gathers all Terraform (`.tf`) files in a module and creates a structured JSON output that can be used as input for Open Policy Agent (OPA) policy evaluation. This enables policy-based validation of Terraform modules.

## Features

- Recursively collects all `.tf` files in a module
- Preserves relative file paths within the module
- Includes file contents for deep inspection
- Creates a structured JSON output for OPA evaluation
- Handles errors gracefully with clear messages

## Usage

The script is primarily used by the `module-validator` script but can also be used directly:

```bash
go run scripts/terraform-file-collector/main.go --module-path providers/aws/primitives/s3-bucket --output terraform-files.json
```

## Command Line Options

- `--module-path`: Path to the Terraform module (required)
- `--output`: Path to output JSON file (required)

## Output Format

The script produces a JSON file with the following structure:

```json
{
  "terraform_files": {
    "main.tf": "# File content here...",
    "variables.tf": "# File content here...",
    "outputs.tf": "# File content here...",
    "examples/basic/main.tf": "# File content here..."
  }
}
```

Each key in the `terraform_files` object is the relative path of a `.tf` file within the module, and the value is the file's content.

## Error Handling

The script exits with a non-zero status code in the following cases:

1. Required command line arguments are missing
2. The module directory cannot be accessed
3. A Terraform file cannot be read
4. The output file cannot be written

Each error is clearly reported with details about what went wrong.

## Implementation Details

The script works by:

1. Parsing command line arguments
2. Walking the module directory recursively
3. Collecting all `.tf` files and their contents
4. Creating a map of relative file paths to file contents
5. Marshaling the map to JSON
6. Writing the JSON to the output file

### File Path Handling

The script uses relative paths within the module as keys in the output JSON. This makes it easier for OPA policies to reason about the module structure without being tied to absolute paths.

## Integration with Module Validation

This script is a key component of the module validation process:

1. The `module-validator` script calls this script to collect Terraform files
2. The output JSON is used as input for OPA policy evaluation
3. OPA policies can inspect both the structure and content of the module
4. Policy violations are reported back to the `module-validator` script

This separation of concerns allows for more maintainable and testable code.