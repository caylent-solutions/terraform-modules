# Terraform Module Structure Requirements

This document outlines the required structure and files for all Terraform modules in this repository.

## Directory Structure

All Terraform modules must follow this structure:

```
terraform-module/
├── examples/                # Example implementations of the module
│   └── example-name/        # At least one example implementation
│       ├── main.tf         
│       ├── variables.tf    
│       ├── versions.tf     
│       ├── terraform.tfvars
│       ├── README.md       
│       └── TERRAFORM-DOCS.md
├── tests/                   # Tests for the module
│   ├── example-name/        # Tests for each example (same name as example)
│   │   ├── module_test.go  
│   │   └── README.md       
│   ├── common/              # Common tests (required if multiple examples)
│   │   ├── module_test.go  
│   │   └── README.md       
│   └── README.md            # Tests documentation
├── main.tf                  # Main module code
├── variables.tf             # Input variables
├── outputs.tf               # Output values (can be empty)
├── versions.tf              # Required providers and versions
├── locals.tf                # Local variables (can be empty)
├── README.md                # Module documentation
├── TERRAFORM-DOCS.md        # Generated Terraform documentation
├── CODEOWNERS               # File ownership information
├── Makefile                 # Automation for common tasks
└── test.config              # Test configuration settings
```

## File Requirements

### Root Directory Files

| File | Required | Can be Empty | Description |
|------|----------|-------------|-------------|
| main.tf | Yes | No | Main module code |
| variables.tf | Yes | No | Input variables |
| outputs.tf | Yes | Yes | Output values |
| versions.tf | Yes | No | Required providers and versions |
| locals.tf | Yes | Yes | Local variables |
| README.md | Yes | No | Module documentation |
| TERRAFORM-DOCS.md | Yes | No | Generated Terraform documentation |
| CODEOWNERS | Yes | No | File ownership information |
| Makefile | Yes | No | Must match the skeleton Makefile |
| test.config | Yes | No | Test configuration with TERRATEST_IDEMPOTENCY setting |

### Example Directory Files

Each example directory must contain:

| File | Required | Can be Empty | Description |
|------|----------|-------------|-------------|
| main.tf | Yes | No | Example implementation |
| variables.tf | Yes | No | Example variables |
| versions.tf | Yes | No | Example provider versions |
| terraform.tfvars | Yes | No | Example variable values |
| README.md | Yes | No | Example documentation |
| TERRAFORM-DOCS.md | Yes | No | Generated example documentation |

### Tests Directory Structure

The tests directory must contain:

1. A README.md file
2. For each directory under `examples/`, there must be a corresponding directory with the same name under `tests/`
3. If there are multiple example directories, a `common/` directory is also required under `tests/`
4. Each test directory must contain:
   - module_test.go
   - README.md



## Test Configuration

The `test.config` file must contain:

```bash
# Test configuration for this module
# This file controls test behavior settings

# Set to true or false to enable/disable idempotency testing
TERRATEST_IDEMPOTENCY=true

# Add other test configuration settings below
```

This file controls test behavior and is required for all modules. The TERRATEST_IDEMPOTENCY setting must be explicitly set to either true or false.

## Additional Requirements

1. **No nested modules**: Terraform modules cannot contain nested modules.
2. **Limited .tf files**: Only main.tf, variables.tf, outputs.tf, versions.tf, and locals.tf are allowed in the root directory.
3. **No hard-coded values**: All values in Terraform code must use variables instead of hard-coded values.
4. **Makefile content**: The Makefile must match the content of the skeleton Makefile.

## Creating a New Module

To create a new module that follows these requirements:

1. Copy the skeleton module:
   ```bash
   cp -r skeletons/generic-skeleton your-new-module
   ```

2. Modify the module files to implement your functionality.

3. Update the examples to demonstrate your module's usage.

4. Write tests to verify your module's functionality.

5. Configure test behavior in the test.config file.

6. Run validation to ensure your module meets all requirements:
   ```bash
   make module-validate MODULE_PATH=your-new-module MODULE_TYPE=<module_type>
   ```

## Documentation
- [Module Structure](terraform-module-structure.md)
- [Module Policies](terraform-module-policies.md)
- [Testing Requirements](terraform-module-testing.md)
- [Complete Workflow Logic](WORKFLOW_LOGIC.md)
- [Main Validation SDLC Guide](main-validation-sdlc.md)
- [Contributing Guidelines](CONTRIBUTING.md)

## Repository Principles

This monorepo enforces the following principles for all modules and services:

- **Self-Contained Repository Deployment Principle:** Every module must be self-contained, including all code, tests, and pipeline logic needed for deployment and validation. See [Self-Contained Repository Deployment Principle](./principles/self-contained-repository-deployment-principle.md).
- **Single Purpose Repository Principle:** Each module must focus on a single responsibility, producing a single, environment-agnostic artifact or service. See [Single Purpose Repository Principle](./principles/single-purpose-repository-principle.md).
- **Poly Repo and Future Mono Repo Support:** This monorepo currently supports a nested poly-repo strategy for module development and deployment. All nested repos will be required to adhere to the same self-contained and single-purpose strategies described here.

## Module Types

- **Primitive Module:**
  - Manages a single major resource type from a provider (e.g., S3, ECS, EC2). Resource blocks are permitted. Must be agnostic, use official providers, and follow the latest skeleton and repo policies. Primitive modules are not a composition of multiple resources or services—they map directly to a single core resource type.

- **Collection Module:**
  - A composition of primitive modules and/or other collection modules. Collection modules can only import other modules (OPA enforced) and cannot contain resource blocks. They provide an opinionated, specialized set of resources to support a use case (e.g., EKS cluster integrated with SumoLogic or Datadog). They do not provide a full reference architecture but are designed to be integrated with reference modules for more complex use cases.

- **Reference Module:**
  - Provides a fully baked, production-ready service that is secure, observable, follows best practices, and modern architecture patterns. Reference modules are a starting point for what good looks like, are known to work reliably, and provide everything needed to serve a function in production.

- **Utility Module:**
  - Adds opinionated functionality (e.g., naming/tagging) or provides data-only structures (such as resource naming constraints for every AWS resource). No resource blocks. Must be agnostic and live in this monorepo.

- **Client Wrapper Module:**
  - Client-specific wrapper that imports reference modules and adds custom logic. Must live in the client’s repo and follow the same structure/testing standards.

## Provider Strategy

- Always use the latest stable official provider.
- If a required feature/bugfix is missing, fork the provider, follow best practices for forking, and upstream changes when possible. See [CONTRIBUTING.md](../CONTRIBUTING.md) for the provider forking workflow.

## Terragrunt Usage

Terragrunt may be used in downstream consumer repositories for orchestration, but all Terraform logic must reside in this monorepo. Terragrunt HCL should only be used for orchestration, not for defining resource logic.