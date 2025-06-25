# Terraform Module Validation

This document describes the validation process for Terraform modules in the monorepo.

## Repository Principles

This monorepo enforces the following principles for all modules and services:

- **Self-Contained Repository Deployment Principle:** Every module must be self-contained, including all code, tests, and pipeline logic needed for deployment and validation. See [Self-Contained Repository Deployment Principle](./principles/self-contained-repository-deployment-principle.md).
- **Single Purpose Repository Principle:** Each module must focus on a single responsibility, producing a single, environment-agnostic artifact or service. See [Single Purpose Repository Principle](./principles/single-purpose-repository-principle.md).

## Module Types

The repository supports several types of Terraform modules, each with specific validation rules:

1. **Utility Modules**
   - Cannot contain Terraform resource blocks
   - Located in `generics/utilities/`

2. **Collection Modules**
   - Cannot contain Terraform resource blocks
   - Must use at least one source Terraform module
   - Located in `providers/*/collections/`

3. **Reference Modules**
   - Cannot contain Terraform resource blocks
   - Must use at least one source Terraform module
   - Located in `providers/*/references/`

4. **Primitive Modules**
   - No specific content restrictions
   - Located in `providers/*/primitives/`

5. **Skeleton Modules**
   - No specific content restrictions
   - Located in `skeletons/`

## Provider Strategy

- Always use the latest stable official provider.
- If a required feature/bugfix is missing, fork the provider, follow best practices for forking, and upstream changes when possible. See [CONTRIBUTING.md](../CONTRIBUTING.md) for the provider forking workflow.

## Validation Process

When a PR is submitted, the following validation steps occur:

1. **Monorepo Policy Check**
   - Ensures PR changes only one module at a time
   - PRs must either modify exactly one module OR only non-module files

2. **Module Type Detection**
   - Determines if changes are in a Terraform module
   - Identifies the module type based on its path

3. **Module-Specific Validation**
   - Runs type-specific OPA policies
   - Performs Terraform linting
   - Checks Terraform formatting
   - Validates Terraform documentation
   - Runs security checks with tfsec
   - Performs a Terraform plan

4. **Functional Testing**
   - Runs comprehensive tests using Caylent's terraform-terratest-framework
   - Tests each example implementation
   - Verifies module functionality and behavior
   - Validates idempotency (configurable via test.config)
   - For external contributors, requires approval before running tests

## Running Validation Locally

You can validate your module locally before submitting a PR:

```bash
# Manually specify module path and type
MODULE_PATH="providers/aws/collections/my-module"
MODULE_TYPE="collection"

# Run module validation
make module-validate MODULE_PATH=$MODULE_PATH MODULE_TYPE=$MODULE_TYPE

# Run Terraform checks
make tf-lint MODULE_PATH=$MODULE_PATH
make tf-format MODULE_PATH=$MODULE_PATH
make tf-docs MODULE_PATH=$MODULE_PATH
make tf-security MODULE_PATH=$MODULE_PATH
make tf-plan MODULE_PATH=$MODULE_PATH

# Run functional tests
make tf-test MODULE_PATH=$MODULE_PATH

# Run OPA policy integration tests
make rego-integration-test
```

## Repository-Wide Testing

For maintainers and CI/CD systems, a comprehensive test suite validates all modules:

```bash
# Test all Terraform modules (used in weekly GitHub Actions)
make test-all-terraform-modules
```

This task discovers all modules and runs the complete validation pipeline (tf-docs-check, tf-format, tf-lint, module-validate, tf-plan, tf-security, tf-test) for each module in parallel. It's designed for automated health checks and not required for individual module development.

Alternatively, you can use the module detection script:

```bash
# Update test_changed_files in monorepo-config.json with your changes
# Then run the detection script and use its output
eval $(make detect-module-changes)

# If changes are in a module, run validation
if [ "$IS_MODULE" = "true" ]; then
  make module-validate MODULE_PATH=$MODULE_PATH MODULE_TYPE=$MODULE_TYPE
  make tf-lint MODULE_PATH=$MODULE_PATH
  # ... other checks
  make tf-test MODULE_PATH=$MODULE_PATH
fi
```

## Test Configuration

Each module must include a `test.config` file that controls test behavior:

```bash
# Test configuration for this module
# This file controls test behavior settings

# Set to true or false to enable/disable idempotency testing
TERRATEST_IDEMPOTENCY=true

# Add other test configuration settings below
```

This configuration is automatically loaded when running tests via `make tf-test`. The main Makefile reads this file and passes the TERRATEST_IDEMPOTENCY setting to the module's Makefile as an environment variable, which is then used by the terraform-terratest-framework to control idempotency testing.

## Adding New Module Types

To add validation for a new module type:

1. Update the `monorepo-config.json` file:
   ```json
   "module_types": {
     "new-type": {
       "path_patterns": ["path/to/new/type/*"],
       "policy_dir": "policies/opa/terraform_module_types/new-type"
     }
   }
   ```

2. Create a new policy directory: `policies/opa/terraform_module_types/new-type/`
3. Add Rego policies with appropriate rules

## Documentation
- [Module Structure](terraform-module-structure.md)
- [Module Policies](terraform-module-policies.md)
- [Testing Requirements](terraform-module-testing.md)
- [Complete Workflow Logic](WORKFLOW_LOGIC.md)
- [Main Validation SDLC Guide](main-validation-sdlc.md)
- [Contributing Guidelines](CONTRIBUTING.md)