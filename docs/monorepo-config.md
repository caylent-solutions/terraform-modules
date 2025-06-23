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

### workflow_tests

Configuration for testing GitHub Actions workflows, specifically the main validation workflow.

```json
"workflow_tests": {
  "test_module": "skeletons/generic-skeleton",
  "test_module_type": "skeleton",
  "repository": "caylent-solutions/terraform-modules",
  "default_inputs": {
    "code_owners": "matt-dresden-caylent",
    "dryrun": "true"
  },
  "variations": [
    {
      "name": "Internal-NonTerraform-SelfApproval",
      "change_type": "non-terraform",
      "contributor_type": "Internal",
      "can_self_approve": "true",
      "description": "Internal contributor making non-terraform changes with self-approval permissions"
    }
  ]
}
```

#### workflow_tests Fields

- **test_module**: Path to the test module used for workflow testing
- **test_module_type**: Type of the test module (must exist in `module_types`)
- **repository**: GitHub repository in "owner/repo" format
- **default_inputs**: Default workflow inputs applied to all test variations
- **variations**: Array of test scenarios to execute

#### variation Fields

Each variation in the `variations` array must include:

- **name**: Unique identifier for the test variation
- **change_type**: Type of change being tested ("terraform" or "non-terraform")
- **contributor_type**: Type of contributor ("Internal" or "External")
- **can_self_approve**: Whether the contributor can self-approve ("true" or "false")
- **description**: Human-readable description of the test scenario
- **inputs** (optional): Additional workflow inputs specific to this variation

This configuration is used by the [Main Validation Script](scripts/main-validation.md) to test all merge approval job variations in the main validation workflow.