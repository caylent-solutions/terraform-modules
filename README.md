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
2. **Separation Policy**: PRs must either modify exactly one module OR only non-module files (not both)
3. **Empty PR Policy**: PRs must contain at least one file change
4. **Module Type Policies**: Each module type has specific content requirements
5. **Module Structure Policies**: All modules must follow a standardized structure
6. **File Organization Policies**: Terraform declarations must be in specific files

These policies are enforced using Open Policy Agent (OPA) in the CI/CD pipeline.

## Security

This repository implements comprehensive security controls:

1. **GitHub Actions Security**: All third-party actions are SHA-pinned to prevent supply chain attacks
2. **External Contributor Protection**: External contributors cannot modify workflow files
3. **Automated Security Scanning**: CodeQL analysis runs on all pull requests
4. **Environment Isolation**: External contributor tests run in protected environments
5. **Manual Approval Gates**: Multiple approval points ensure code quality and security
6. **Action Allowlist**: Only pre-approved GitHub Actions can be used in workflows

Security is managed through automated scripts in the [`security-scripts/`](security-scripts/) directory. Use `make github-actions-security` to update action allowlists.

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
6. Format and lint your code: `make go-format` and `make go-lint`
7. Validate your module: `make module-validate MODULE_PATH=your/new/module MODULE_TYPE=module_type`
8. Test all non-Terraform code: `make test-all-non-tf-module-code`
9. Submit a PR

### Workflow Development and Testing

For developers working on the main validation workflow (`.github/workflows/main-validation.yml`):

```bash
# Test all 6 merge approval job variations in dry run mode
make test-main-validation-workflow
```

This comprehensive test triggers all possible merge approval scenarios to validate workflow changes before deployment. See [Main Validation Script Documentation](docs/scripts/main-validation.md) for details.

### Repository Health Checks

For repository maintainers, a comprehensive test suite is available to validate all Terraform modules:

```bash
# Test all Terraform modules (runs weekly via GitHub Actions)
make test-all-terraform-modules
```

This task runs the full validation suite (documentation, formatting, linting, OPA policies, planning, security, and tests) across all modules in parallel. It's designed for CI/CD use and not required for regular development.

For detailed contribution guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md).

## CI/CD Pipeline

This repository implements a comprehensive automated CI/CD pipeline that handles different contributor types and change types:

### Security Features

- **GitHub Actions Security**: All third-party actions are SHA-pinned to prevent supply chain attacks
- **External Contributor Protection**: External contributors cannot modify workflow files
- **Automated Security Scanning**: CodeQL analysis runs on all pull requests in parallel with validation
- **Environment Isolation**: External contributor tests run in protected environments
- **Manual Approval Gates**: Multiple approval points ensure code quality and security
- **Action Allowlist**: Only pre-approved GitHub Actions can be used (managed via `make github-actions-security`)

### Pull Request Workflow

1. **Security Check** (`pr-validation.yml`):
   - **Contributor Validation**: Determines if contributor is internal (Caylent) or external
   - **Workflow Protection**: Blocks external contributors from modifying `.github/workflows/` files
   - **Access Control**: Uses GitHub App tokens for elevated permissions

2. **Entry Point** (`pr-validation.yml`):
   - Triggers on all PRs to `main` branch
   - Simulates merge to test compatibility
   - Detects change type (Terraform modules vs non-Terraform)
   - Routes to appropriate validation workflow

3. **Terraform Module Validation** (`terraform-module-validation.yml`):
   - **Parallel Security Scanning**: CodeQL analysis runs alongside validation
   - **Comprehensive Validation**: Policies, linting, formatting, docs, security, planning
   - **Contributor-Aware Testing**:
     - **Internal Contributors**: Automatic test execution
     - **External Contributors**: Manual approval required for test execution in protected environment
   - **Automated Merge**: After code owner approval
   - **Post-Merge Validation**: Re-runs all checks on merged code
   - **QA Gate**: Manual certification required before release

4. **Non-Terraform Validation** (`non-terraform-validation.yml`):
   - **Parallel Security Scanning**: CodeQL analysis
   - **Code Quality Checks**: Go and Rego linting, formatting, unit tests
   - **Coverage Requirements**: 95% minimum test coverage for Rego code
   - **Integration Testing**: End-to-end policy validation
   - **Automated Merge**: After code owner approval
   - **QA Certification**: Manual approval for release

5. **Release Process** (`release.yml`):
   - **Semantic Versioning**: Automatic version determination
   - **Module-Specific Releases**: Individual versioning for Terraform modules
   - **Repository-Wide Releases**: For non-Terraform changes
   - **Automated Changelog**: Generated from conventional commits

### Monitoring

- **Pre-Merge Security Scanning**: CodeQL analysis on all PRs
- **Post-Merge Security Scanning**: Additional scanning on main branch
- **External Contributor Protection**: Manual approval required for test execution
- **Environment Isolation**: Protected environments for external contributions
- **Multiple Approval Gates**: Code owners and QA certification required
- **GitHub Actions Security**: SHA-pinned actions prevent supply chain attacks

### Monitoring

- **Weekly Health Checks**: All modules tested weekly via `weekly-module-health-check.yml`
- **Slack Notifications**: Team notifications for reviews, approvals, and releases
- **Comprehensive Logging**: Full audit trail of all automated processes

## Documentation

### Contributor Guides
- [Contributing Guidelines](CONTRIBUTING.md) - How to contribute (internal vs external)
- [Contributor Guide - SDLC Process](CONTRIBUTOR_GUIDE.md) - Complete development lifecycle
- [Workflow Logic Documentation](docs/WORKFLOW_LOGIC.md) - Detailed CI/CD flow explanation
- [Main Validation SDLC Guide](docs/main-validation-sdlc.md) - SDLC process for workflow maintenance

### Technical Documentation
- [Terraform Module Structure](docs/terraform-module-structure.md)
- [Terraform Module Policies](docs/terraform-module-policies.md)
- [Terraform Module Testing](docs/terraform-module-testing.md)
- [Module Validation](docs/module-validation.md)
- [Monorepo Configuration](docs/monorepo-config.md)

### Scripts Documentation
- [Scripts Documentation Index](docs/scripts/README.md) - Complete index of all scripts
- [GitHub Actions Security Scripts](security-scripts/README.md) - Secure GitHub Actions management
- [Detect Proposed Git Repo Changes](docs/scripts/detect-proposed-git-repo-changes.md)
- [Go Format](docs/scripts/go-format.md)
- [Go Lint](docs/scripts/go-lint.md)
- [Go Unit Test](docs/scripts/go-unit-test.md)
- [Install Tools](docs/scripts/install-tools.md)
- [Main Validation](docs/scripts/main-validation.md) - End-to-end workflow testing
- [Module Type Validator](docs/scripts/module-type-validator.md)
- [Module Validator](docs/scripts/module-validator.md)
- [Rego Unit Test](docs/scripts/rego-unit-test.md)
- [Terraform File Collector](docs/scripts/terraform-file-collector.md)