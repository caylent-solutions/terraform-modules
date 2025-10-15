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

### provider

Defines providers, their module types, and associated policies. The configuration is organized hierarchically: provider → module_types → type configuration.

```json
"provider": {
  "aws": {
    "module_types": {
      "primitive": {
        "path_patterns": ["providers/aws/primitives/*"],
        "policy_dir": "policies/opa/terraform/provider/aws/module_types/primitive"
      },
      "collection": {
        "path_patterns": ["providers/aws/collections/*"],
        "policy_dir": "policies/opa/terraform/provider/aws/module_types/collection"
      },
      "reference": {
        "path_patterns": ["providers/aws/references/*"],
        "policy_dir": "policies/opa/terraform/provider/aws/module_types/reference"
      },
      "data": {
        "path_patterns": ["providers/aws/data/*"],
        "policy_dir": "policies/opa/terraform/provider/aws/module_types/data"
      }
    }
  },
  "github": {
    "module_types": {
      "primitive": {
        "path_patterns": ["providers/github/primitives/*"],
        "policy_dir": "policies/opa/terraform/provider/github/module_types/primitive"
      },
      "collection": {
        "path_patterns": ["providers/github/collections/*"],
        "policy_dir": "policies/opa/terraform/provider/github/module_types/collection"
      },
      "reference": {
        "path_patterns": ["providers/github/references/*"],
        "policy_dir": "policies/opa/terraform/provider/github/module_types/reference"
      },
      "data": {
        "path_patterns": ["providers/github/data/*"],
        "policy_dir": "policies/opa/terraform/provider/github/module_types/data"
      }
    }
  },
  "none": {
    "module_types": {
      "skeleton": {
        "path_patterns": ["skeletons/*"],
        "policy_dir": "policies/opa/terraform/provider/none/module_types/skeleton"
      },
      "utility": {
        "path_patterns": ["generics/utilities/*"],
        "policy_dir": "policies/opa/terraform/provider/none/module_types/utilities"
      }
    }
  }
}
```

### scripts

Configuration for various scripts used in the monorepo.

```json
"scripts": {
  "terraform_file_collector": "terraform-file-collector",
  "temp_file_pattern": "terraform-files-*.json",
  "go_unit_test": "./scripts/go-unit-test/main.go",
  "rego_unit_test": "./scripts/rego-unit-test/main.go",
  "excluded_dirs": [".terraform", ".git", "node_modules", ".terragrunt-cache"],
  "important_dirs": ["examples", "tests"],
  "directory_marker": "directory",
  "lint_directories": [
    "scripts/detect-proposed-git-repo-changes",
    "scripts/go-format",
    "scripts/go-lint",
    "scripts/go-unit-test",
    "scripts/install-tools",
    "scripts/main-validation",
    "scripts/module-type-validator",
    "scripts/module-validator",
    "scripts/rego-unit-test",
    "scripts/terraform-file-collector"
  ]
}
```

### rego_tests

List of rego test directories.

```json
"rego_tests": [
  "tests/opa/unit/global",
  "tests/opa/unit/terraform/libraries"
]
```

### rego_policy_dirs

Maps test directories to their corresponding policy directories.

```json
"rego_policy_dirs": {
  "tests/opa/unit/global": "policies/opa/global",
  "tests/opa/unit/terraform/libraries": "policies/opa/terraform/libraries",
  "policies/opa/terraform/provider": "policies/opa/terraform/provider",
  "policies/opa/terraform/libraries": "policies/opa/terraform/libraries"
}
```

### rego_helpers_dir

Directory containing rego helper files.

```json
"rego_helpers_dir": "tests/opa/unit/helpers"
```

### terraform_module_opa_library_bundle

Path to the OPA library bundle containing shared policy libraries used by module validation.

```json
"terraform_module_opa_library_bundle": "policies/opa/terraform/libraries"
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
    },
    {
      "name": "Internal-NonTerraform-ManualApproval",
      "change_type": "non-terraform",
      "contributor_type": "Internal",
      "can_self_approve": "false",
      "description": "Internal contributor making non-terraform changes requiring manual approval"
    },
    {
      "name": "External-NonTerraform-ManualApproval",
      "change_type": "non-terraform",
      "contributor_type": "External",
      "can_self_approve": "false",
      "description": "External contributor making non-terraform changes (always requires manual approval)"
    },
    {
      "name": "Internal-Terraform-SelfApproval",
      "change_type": "terraform",
      "contributor_type": "Internal",
      "can_self_approve": "true",
      "description": "Internal contributor making terraform changes with self-approval permissions"
    },
    {
      "name": "Internal-Terraform-ManualApproval",
      "change_type": "terraform",
      "contributor_type": "Internal",
      "can_self_approve": "false",
      "description": "Internal contributor making terraform changes requiring manual approval"
    },
    {
      "name": "External-Terraform-ManualApproval",
      "change_type": "terraform",
      "contributor_type": "External",
      "can_self_approve": "false",
      "description": "External contributor making terraform changes (always requires manual approval)"
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
  },
  {
    "name": "Detect Proposed Git Repo Changes",
    "emoji": "🔍",
    "outputFile": "detect-proposed-git-repo-changes.out",
    "testPath": "./scripts/detect-proposed-git-repo-changes",
    "coverPkg": "./scripts/detect-proposed-git-repo-changes"
  },
  {
    "name": "Install Tools",
    "emoji": "🔧",
    "outputFile": "go-unit-test.out",
    "testPath": "./scripts/go-unit-test",
    "coverPkg": "./scripts/go-unit-test"
  },
  {
    "name": "Module Type Validator",
    "emoji": "✅",
    "outputFile": "module-type-validator.out",
    "testPath": "./scripts/module-type-validator",
    "coverPkg": "./scripts/module-type-validator"
  },
  {
    "name": "Main Validation",
    "emoji": "🔎",
    "outputFile": "main-validation.out",
    "testPath": "./scripts/main-validation",
    "coverPkg": "./scripts/main-validation"
  },
  {
    "name": "Module Validator",
    "emoji": "🔎",
    "outputFile": "module-validator.out",
    "testPath": "./scripts/module-validator",
    "coverPkg": "./scripts/module-validator"
  },
  {
    "name": "Terraform File Collector",
    "emoji": "📁",
    "outputFile": "terraform-file-collector.out",
    "testPath": "./scripts/terraform-file-collector",
    "coverPkg": "./scripts/terraform-file-collector"
  },
  {
    "name": "Lint",
    "emoji": "🧹",
    "outputFile": "lint.out",
    "testPath": "./scripts/go-lint",
    "coverPkg": "./scripts/go-lint"
  },
  {
    "name": "Rego Unit Test",
    "emoji": "🔍",
    "outputFile": "rego-unit-test.out",
    "testPath": "./scripts/rego-unit-test",
    "coverPkg": "./scripts/rego-unit-test"
  }
]
```

## Documentation
- [Module Structure](terraform-module-structure.md)
- [Module Policies](terraform-module-policies.md)
- [Testing Requirements](terraform-module-testing.md)
- [Complete Workflow Logic](WORKFLOW_LOGIC.md)
- [Main Validation SDLC Guide](main-validation-sdlc.md)
- [Contributing Guidelines](CONTRIBUTING.md)