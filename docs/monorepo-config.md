# Monorepo Configuration

This document describes the centralized configuration file used for all monorepo automation.

## Overview

The `monorepo-config.json` file serves as a single source of truth for all configuration related to the monorepo's automation, including:

- Module root directories
- Module type definitions and path patterns
- Script paths and parameters
- Test data for local validation

## File Structure

```json
{
  "module_roots": [
    "generics/utilities/",
    "providers/aws/collections/",
    "providers/aws/primitives/",
    "providers/aws/references/",
    "providers/github/collections/",
    "providers/github/primitives/",
    "providers/github/references/",
    "skeletons/"
  ],
  "test_changed_files": [
    "providers/aws/collections/example-module/main.tf",
    "providers/aws/collections/example-module/variables.tf"
  ],
  "module_types": {
    "skeleton": {
      "path_patterns": ["skeletons/*"],
      "policy_dir": "policies/opa/terraform_module_types/skeleton"
    },
    "utility": {
      "path_patterns": ["generics/utilities/*"],
      "policy_dir": "policies/opa/terraform_module_types/utility"
    },
    "primitive": {
      "path_patterns": ["providers/*/primitives/*"],
      "policy_dir": "policies/opa/terraform_module_types/primitive"
    },
    "collection": {
      "path_patterns": ["providers/*/collections/*"],
      "policy_dir": "policies/opa/terraform_module_types/collection"
    },
    "reference": {
      "path_patterns": ["providers/*/references/*"],
      "policy_dir": "policies/opa/terraform_module_types/reference"
    }
  },
  "scripts": {
    "terraform_file_collector": "./scripts/terraform-file-collector/main.go",
    "temp_file_pattern": "terraform-files-*.json"
  }
}
```

## Configuration Sections

### module_roots

List of directories that contain Terraform modules. Used by the PR policy checker to determine which files are part of modules.

### test_changed_files

List of files that have changed in the current PR or local test. This is automatically updated by the CI/CD pipeline with actual changed files.

### module_types

Defines the different types of modules in the monorepo:

- **path_patterns**: Glob patterns used to match module paths
- **policy_dir**: Directory containing OPA policies specific to this module type

### scripts

Configuration for various scripts used in the monorepo:

- **terraform_file_collector**: Path to the script that collects Terraform files
- **temp_file_pattern**: Pattern for temporary files created during validation

## Usage in Scripts

All automation scripts in the monorepo read from this configuration file:

```go
// Load configuration
config, err := loadConfig(*configPath)
if err != nil {
    fmt.Printf("Error loading configuration: %v\n", err)
    os.Exit(1)
}

// Access configuration values
moduleTypes := config["module_types"].(map[string]interface{})
```

## Updating the Configuration

When adding new module types or changing the repository structure:

1. Update the `module_roots` list if adding new root directories
2. Add or modify entries in the `module_types` section
3. Update any script paths or parameters in the `scripts` section

All scripts will automatically use the updated configuration without requiring code changes.