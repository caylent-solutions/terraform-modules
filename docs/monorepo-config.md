# Monorepo Configuration

This document describes the structure and purpose of the `monorepo-config.json` file.

## Overview

The `monorepo-config.json` file contains configuration settings for various tools and scripts used in the monorepo.

## Configuration Sections

### module_roots

List of root directories where modules are located.

```json
"module_roots": [
  "generics/utilities/",
  "providers/aws/collections/",
  "providers/aws/primitives/",
  "providers/aws/references/",
  "providers/github/collections/",
  "providers/github/primitives/",
  "providers/github/references/",
  "skeletons/"
]
```

### module_types

Defines the different types of modules and their associated policies.

```json
"module_types": {
  "skeleton": {
    "path_patterns": ["skeletons/*"],
    "policy_dir": "policies/opa/terraform/module_types/skeleton"
  },
  "utility": {
    "path_patterns": ["generics/utilities/*"],
    "policy_dir": "policies/opa/terraform/module_types/utility"
  }
}
```

### scripts

Configuration for various scripts used in the monorepo.

```json
"scripts": {
  "terraform_file_collector": "terraform-file-collector",  // Script to collect Terraform files
  "temp_file_pattern": "terraform-files-*.json",           // Pattern for temporary files
  "excluded_dirs": [".terraform", ".git", "node_modules"], // Directories to exclude when collecting files
  "important_dirs": ["examples", "tests"],                 // Important directories to mark in the output
  "directory_marker": "directory"                          // Value to use for marking directories in the output
}
```

### rego_policy_dirs

Maps test directories to their corresponding policy directories.

```json
"rego_policy_dirs": {
  "tests/opa/unit/global": "policies/opa/global",
  "tests/opa/unit/terraform/module": "policies/opa/terraform/module"
}
```

### module_validator_additional_policies

List of additional policy directories to include when validating modules.

```json
"module_validator_additional_policies": [
  "tests/opa/unit/terraform/module",
  "tests/opa/unit/terraform/provider"
]
```

### coverage_groups

Configuration for test coverage reporting.

```json
"coverage_groups": [
  {
    "name": "Go Unit Test",
    "emoji": "🧪",
    "outputFile": "go-unit-test.out",
    "testPath": "./scripts/go-unit-test",
    "coverPkg": "./scripts/go-unit-test"
  }
]
```