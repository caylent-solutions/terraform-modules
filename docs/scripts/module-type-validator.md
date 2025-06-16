# Module Type Validator Script

This document describes the script used to detect and validate the type of Terraform modules in the monorepo.

## Overview

The `module-type-validator` script analyzes a Terraform module's path to determine its type based on the path patterns defined in the monorepo configuration. This is essential for applying the correct validation rules and policies to each module.

## Features

- Automatically detects module type based on its path
- Uses path patterns from the monorepo configuration
- Supports all module types defined in the configuration
- Outputs the detected module type for use in CI/CD pipelines

## Usage

The script is primarily used in CI/CD pipelines to determine the type of a module:

```bash
go run scripts/module-type-validator/main.go --module-path providers/aws/primitives/s3-bucket --config monorepo-config.json
```

## Command Line Options

- `--module-path`: Path to the Terraform module (required)
- `--config`: Path to the monorepo configuration file (required)

## Configuration

The script uses the `module_types` section from the `monorepo-config.json` file, which defines the path patterns for each module type:

```json
"module_types": {
  "utility": {
    "path_patterns": ["generics/utilities/*"],
    "policy_dir": "policies/opa/terraform/module_types/utilities"
  },
  "collection": {
    "path_patterns": ["providers/*/collections/*"],
    "policy_dir": "policies/opa/terraform/module_types/collection"
  },
  "reference": {
    "path_patterns": ["providers/*/references/*"],
    "policy_dir": "policies/opa/terraform/module_types/reference"
  },
  "primitive": {
    "path_patterns": ["providers/*/primitives/*"],
    "policy_dir": "policies/opa/terraform/module_types/primitive"
  },
  "skeleton": {
    "path_patterns": ["skeletons/*"],
    "policy_dir": "policies/opa/terraform/module_types/skeleton"
  }
}
```

## Output

The script outputs the detected module type:

```
MODULE_TYPE=primitive
```

In GitHub Actions, this is also set as an output using the `::set-output` syntax.

## Error Handling

The script exits with a non-zero status code in the following cases:

1. Required command line arguments are missing
2. The configuration file cannot be read or parsed
3. The `module_types` section is missing from the configuration

If the module type cannot be determined, the script outputs `MODULE_TYPE=unknown`.

## Implementation Details

The script works by:

1. Loading the monorepo configuration
2. Getting the absolute path of the module
3. Checking the module path against each pattern in the configuration
4. Returning the first matching module type
5. If no match is found, returning "unknown"

### Pattern Matching

The script converts glob patterns from the configuration into regular expressions for matching. For example:

- `providers/*/primitives/*` becomes a regex that matches paths like `providers/aws/primitives/s3-bucket`
- `generics/utilities/*` becomes a regex that matches paths like `generics/utilities/conditional`

## Integration with CI/CD

This script is typically used in the PR validation workflow after detecting that a PR contains module changes. It determines the specific type of module being modified, which is then used to apply the appropriate validation rules and policies.