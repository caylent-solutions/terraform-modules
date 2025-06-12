# Terraform Modules Monorepo

This repository contains a collection of Terraform modules organized in a poly-repo style layout, split by provider, abstraction level, and purpose.

## Repository Structure

```
.
├── generics
│   └── utilities/            # Terraform modules
├── providers
│   ├── aws/
│   │   ├── collections/      # Terraform modules
│   │   ├── primitives/       # Terraform modules
│   │   └── references/       # Terraform modules
│   └── github/
│       ├── collections/      # Terraform modules
│       ├── primitives/       # Terraform modules
│       └── references/       # Terraform modules
└── skeletons                 # Terraform modules
    └── generic-skeleton/
```

## Governance

This repository implements governance policies to ensure consistent and maintainable code:

1. **Single Module Policy**: PRs must change only one Terraform module at a time
2. **Monorepo Code Policy**: PRs modifying non-module files must not touch module files
3. **Empty PR Policy**: PRs must contain at least one file change
4. **Module Type Policies**: Each module type has specific content requirements
5. **Module Structure Policies**: All modules must follow a standardized structure
6. **File Organization Policies**: Terraform declarations must be in specific files

These policies are enforced using Open Policy Agent (OPA) and can be tested locally using:

```bash
make pr-opa-policy-test
```

## Module Types

The repository supports several types of Terraform modules:

1. **Utility Modules**: Reusable code without resource blocks
2. **Collection Modules**: Compositions of other modules without direct resources
3. **Reference Modules**: Reference implementations using other modules
4. **Primitive Modules**: Basic building blocks that can contain resources
5. **Skeleton Modules**: Template modules for new module development

See [Module Validation](docs/module-validation.md) and [Module Structure](docs/terraform-module-structure.md) for details on the requirements for each type.

## Module Structure

All modules must follow a standardized structure:

- Required files in the root directory (main.tf, variables.tf, etc.)
- Examples directory with at least one example implementation
- Tests directory with corresponding test directories for each example
- Documentation in README.md and TERRAFORM-DOCS.md

See [Module Structure](docs/terraform-module-structure.md) and [Module Policies](docs/terraform-module-policies.md) for detailed requirements.

## Testing Requirements

All modules must include comprehensive functional tests using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework):

- Tests for each example implementation
- Common tests that verify basic functionality
- Tests that validate the module's core features
- Tests that ensure inputs are properly processed

See [Module Testing](docs/terraform-module-testing.md) for detailed testing requirements and examples.

## Configuration

All monorepo automation is configured through a single centralized file:

```bash
monorepo-config.json
```

This file defines module types, path patterns, policy directories, and other configuration used by all automation scripts. See [Monorepo Configuration](docs/monorepo-config.md) for details.

## Getting Started

### Prerequisites

This repository uses [ASDF](https://asdf-vm.com/) v0.15.0 to manage tool versions:

```bash
# Install required tools
make install-tools
```

### Development Workflow

1. Clone the repository
2. Install required tools: `make install-tools`
3. Configure the environment: `make configure`
4. Create a new module from the skeleton: `cp -r skeletons/generic-skeleton your/new/module`
5. Implement your module following the [structure requirements](docs/terraform-module-structure.md)
6. Format and lint your code: `make format` and `make lint`
7. Test your changes locally: `make pr-opa-policy-test`
8. Validate your module: `make module-validate MODULE_PATH=your/new/module MODULE_TYPE=module_type`
9. Submit a PR

For detailed contribution guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md).

## CI/CD

Pull requests are automatically validated using GitHub Actions:

- The `pr-validation.yml` workflow runs on all PRs to the `main` branch
- It simulates a merge with the target branch
- It installs system dependencies and tools
- It checks your changes against the monorepo policies
- Based on the type of changes, it triggers either:
  - `terraform-module-validation.yml` for Terraform module changes
  - `non-terraform-validation.yml` for non-Terraform changes

## Documentation

- [Contributing Guidelines](CONTRIBUTING.md)
- [Terraform Module Structure](docs/terraform-module-structure.md)
- [Terraform Module Policies](docs/terraform-module-policies.md)
- [Terraform Module Testing](docs/terraform-module-testing.md)
- [Module Validation](docs/module-validation.md)
- [Monorepo Configuration](docs/monorepo-config.md)
- [PR OPA Policy Test Script](docs/scripts/pr-opa-policy-test.md)