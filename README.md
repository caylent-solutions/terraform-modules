# Terraform Modules Monorepo

> **🚀 Welcome to the Caylent Terraform Module Hub**  
>
> **Your one-stop shop for production-grade, security-hardened, and fully tested Terraform modules—purpose-built for AWS and the modern cloud.**

---

## 👥 Who This Repo Is For

Whether you're a platform engineer, DevOps specialist, cloud architect, or developer — this repo is built to help you:

- **🚀 Deliver faster:** Instantly adopt proven modules for AWS and common integrations like GitHub, and more to come.
- **🔐 Ship with confidence:** Every module is policy-enforced, security-audited, and functionally tested.
- **🔌 Integrate seamlessly:** Built for AWS-first platforms, but extensible to broader cloud-native and SaaS ecosystems.
- **⚡ Start fast:** Browse, copy, and apply modules with minimal setup. See [Getting Started](#getting-started) to dive in.

> **Most users simply consume modules—no customization required.**

---

_Ready to move? Jump to [Getting Started](#getting-started) or explore the [Module Types](#module-types)._

---

## 📦 How to Use: Sourcing & Importing Modules

To use any module from this repo, reference it directly in your Terraform configuration using the Git source and a version tag:

```hcl
module "generic_skeleton" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//skeletons/generic-skeleton?ref=skeletons/generic-skeleton/v1.0.0"
  # ...module inputs...
}
```

- Replace the module path (`skeletons/generic-skeleton`) with the one you need.
- Replace the version (`v1.0.0`) with the exact tag to pin the module version.  
  ⚠️ **Pinning is required** — Terraform’s `git` source does not support version ranges.

---

### 🏗 Coming Soon: Caylent Public Terraform Registry

You’ll soon be able to consume modules directly via a public Caylent registry:

- Native support for version constraints (e.g., `~> 1.2`)
- No authentication required
- Backed by this GitHub repo
- Fully audited, tested, and production-ready modules

_Stay tuned for release announcements._

---

## 📋 Table of Contents
- [Who This Repo Is For](#who-this-repo-is-for)
- [How to Use: Sourcing & Importing Modules](#how-to-use-sourcing--importing-modules)
- [Coming Soon: Caylent Public Terraform Registry](#coming-soon-caylent-public-terraform-registry)
- [Repository Structure](#repository-structure)
- [Governance](#governance)
- [Security](#security)
- [Repository Principles and Strategy](#repository-principles-and-strategy)
- [Module Types](#module-types)
- [Terraform Provider Strategy](#terraform-provider-strategy)
- [Module Structure](#module-structure)
- [Testing Requirements](#testing-requirements)
- [Configuration](#configuration)
- [Getting Started](#getting-started)
- [Workflow Development and Testing](#workflow-development-and-testing)
- [Repository Health Checks](#repository-health-checks)
- [CI/CD Workflows Overview](#cicd-workflows-overview)
- [Contribution Process](#contribution-process)
- [Documentation](#documentation)

## 🧱 Repository Structure

A clear, logical structure for all modules and supporting files:

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

## 🔐 Governance

This repository implements governance policies to ensure consistent and maintainable code:

1. **Single Module Policy**: PRs must change only one Terraform module at a time
2. **Separation Policy**: PRs must either modify exactly one module OR only non-module files (not both)
3. **Empty PR Policy**: PRs must contain at least one file change
4. **Module Type Policies**: Each module type has specific content requirements
5. **Module Structure Policies**: All modules must follow a standardized structure
6. **File Organization Policies**: Terraform declarations must be in specific files

These policies are enforced using Open Policy Agent (OPA) in the CI/CD pipeline.

## 🛡️ Security

This repository implements comprehensive security controls:

1. **GitHub Actions Security**: All third-party actions are SHA-pinned to prevent supply chain attacks
2. **External Contributor Protection**: External contributors cannot modify workflow files
3. **Automated Security Scanning**: CodeQL analysis runs on all pull requests
4. **Terraform Security Scanning**: `tfsec` scans every Terraform module change for security issues
5. **Environment Isolation**: External contributor tests run in protected environments
6. **Manual Approval Gates**: Multiple approval points ensure code quality and security
7. **Action Allowlist**: Only pre-approved GitHub Actions can be used in workflows

Security is managed through automated scripts in the [`security-scripts/`](security-scripts/) directory. Use `make github-actions-security` to update action allowlists.

## 🧭 Repository Principles and Strategy

This monorepo is governed by the following principles, which guide all module and service development:

### Self-Contained Repository Deployment Principle
Each module or service in this monorepo is designed to be self-contained, including everything necessary to deploy, test, and validate itself in isolation. This ensures autonomy, reproducibility, and a complete SDLC for every module. See [Self-Contained Repository Deployment Principle](docs/principles/self-contained-repository-deployment-principle.md) for details.

### Single Purpose Repository Principle
Every module or service is focused on a single responsibility, producing a single, environment-agnostic artifact or service. This aligns with the [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single-responsibility_principle) and supports modular, maintainable, and scalable infrastructure. See [Single Purpose Repository Principle](docs/principles/single-purpose-repository-principle.md) for details.

### Terraform Module Strategy
- All cloud, SaaS, and stateful resources are managed via Terraform modules in this monorepo.
- Module types include: Primitive, Utility, Reference, and Client Wrapper modules (see below).
- Modules must be client- and application-agnostic unless explicitly a client wrapper.
- All modules must be created using the latest skeleton and follow all OPA policies, structure, and testing requirements defined in this repo.
- All modules must be semantically versioned and released via CI/CD.
- Use official Terraform providers unless a fork is required for missing features/bugfixes (see CONTRIBUTING for provider forking strategy).

### Terragrunt Usage
Terragrunt may be used in downstream consumer repositories to orchestrate deployments of modules from this monorepo. However, all Terraform code and module logic must reside in this repo, and Terragrunt HCL should only be used for orchestration, not for defining resource logic.

## 🧱 Module Types

This repository supports several types of Terraform modules, each with a specific purpose and scope:

1. **Primitive Modules**: Basic building blocks that manage a single resource type. Resource blocks are permitted. Must be agnostic and use official providers where possible.
2. **Utility Modules**: Opinionated helpers that add functionality (e.g., naming/tagging). No resource blocks allowed. Must be agnostic and live in this monorepo.
3. **Reference Modules**: Collections of primitives/utilities that provide a reference architecture or service. Must be agnostic and tested for integration.
4. **Client Wrapper Modules**: Client-specific wrappers that import reference modules and add custom logic. Must live in the client’s repo and follow the same structure/testing standards.

All modules must:
- Use the latest skeleton
- Pass all OPA policies and CI/CD checks
- Be fully tested (rego and Terratest)
- Be semantically versioned and released via CI/CD
- Use Apache 2.0 license unless client-specific

## 📦 Terraform Provider Strategy

- Always use the latest stable official provider for all resources.
- If a required feature/bugfix is missing, fork the provider, follow best practices for forking, and upstream changes when possible. See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for the full provider forking workflow.

## 📁 Module Structure

All modules must follow a standardized structure:

- Required files in the root directory (main.tf, variables.tf, etc.)
- Examples directory with at least one example implementation
- Tests directory with corresponding test directories for each example
- Documentation in README.md and TERRAFORM-DOCS.md

See [Module Structure](docs/terraform-module-structure.md) and [Module Policies](docs/terraform-module-policies.md) for detailed requirements.

## 🧪 Testing Requirements

All modules must include comprehensive functional tests using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework):

- Tests for each example implementation
- Common tests that verify basic functionality
- Tests that validate the module's core features
- Tests that ensure inputs are properly processed

See [Module Testing](docs/terraform-module-testing.md) for detailed testing requirements and examples.

## ⚙️ Configuration

All monorepo automation is configured through a single centralized file:

```bash
monorepo-config.json
```

This file defines module types, path patterns, policy directories, and other configuration used by all automation scripts. See [Monorepo Configuration](docs/monorepo-config.md) for details.

## 🚀 Getting Started

Follow these steps to get up and running as a contributor or consumer:

### Prerequisites

This repository uses [ASDF](https://asdf-vm.com/) v0.15.0 to manage tool versions:

```bash
# Install required tools for the monorepo
make install-tools
```

### Development Workflow

1. Clone the repository
2. Install required tools: `make install-tools`
3. Configure the environment: `make configure`
4. Create a new module from the skeleton: `cp -r skeletons/generic-skeleton your/new/module`
5. Enter your module directory and install module dependencies: `cd your/new/module && make install`
6. Implement your module following the [structure requirements](docs/terraform-module-structure.md)
7. Format and lint your code:
   - For Go code in the monorepo: `make go-format` and `make go-lint`
   - For Go code in a module: `make go-format` and `make go-lint` (from the module directory)
8. Generate and check Terraform documentation in a module:
   - `make tf-docs` (generate docs)
   - `make tf-docs-check` (verify docs are up to date)
9. Validate your module:
   - From the repo root: `make module-validate MODULE_PATH=your/new/module MODULE_TYPE=module_type`
10. Test your module:
    - From the module directory: `make test` (runs all tests)
    - `make test-common` (runs only common tests)
11. Clean up module files:
    - `make clean` (removes Terraform and state files)
    - `make clean-all` (also cleans Go cache)
12. Test all non-Terraform code: `make test-all-non-tf-module-code` (from repo root)
13. Submit a PR

## 🧪 Workflow Development and Testing

For developers working on the main validation workflow (`.github/workflows/main-validation.yml`):

```bash
# Test all 6 merge approval job variations in dry run mode
make test-main-validation-workflow
```

This comprehensive test triggers all possible merge approval scenarios to validate workflow changes before deployment. See [Main Validation Script Documentation](docs/scripts/main-validation.md) for details.

## ✅ Repository Health Checks

For repository maintainers, a comprehensive test suite is available to validate all Terraform modules:

```bash
# Test all Terraform modules (runs weekly via GitHub Actions)
make test-all-terraform-modules
```

This task runs the full validation suite (documentation, formatting, linting, OPA policies, planning, security, and tests) across all modules in parallel. It's designed for CI/CD use and not required for regular development.

For detailed contribution guidelines, see [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).

## 🔁 CI/CD Workflows Overview

This repository uses a multi-stage, automated CI/CD pipeline to ensure code quality, security, and compliance for all contributions. The workflows support both production and dry run (safe testing) modes.

### Main Workflows

- **PR Validation (`pr-validation.yml`)**: Entry point for all pull requests. Detects contributor type (internal/external), enforces workflow file protection, and routes PRs to the correct validation workflow based on whether Terraform modules or non-Terraform code are changed.
- **Main Validation (`main-validation.yml`)**: Core workflow for PR approval, merge decisions, and release orchestration. Handles both Terraform and non-Terraform changes, supports dry run mode, and manages merge approval routing.
- **Release (`release.yml`)**: Handles both Terraform and non-Terraform releases. Uses custom logic for module versioning and `python-semantic-release` for non-Terraform code. Automates changelog generation and tagging.
- **CodeQL Analysis (`codeql-analysis.yml`)**: Runs automated security scanning on all pushes and PRs.
- **Weekly Module Health Check (`weekly-module-health-check.yml`)**: Runs comprehensive tests on all Terraform modules weekly and on demand.

### Security Features
- **Workflow File Protection**: External contributors cannot modify workflow files. Internal contributors must follow the SDLC process for workflow changes.
- **Automated Security Scanning**: CodeQL analysis runs on all PRs and pushes.
- **Manual Approval Gates**: Maintainers must approve PRs and test execution for external contributors.
- **Environment Isolation**: Tests for external contributors run in protected environments.
- **Action Allowlist**: Only SHA-pinned, pre-approved GitHub Actions are permitted.

### Pull Request Flow
1. **Security Check**: Validates contributor type and workflow file changes.
2. **Change Detection**: Determines if the PR changes a Terraform module or only non-module files.
3. **Validation**: Runs comprehensive policy, linting, formatting, documentation, and security checks.
4. **Testing**: Executes full test suite (automatic for internal, manual approval for external contributors).
5. **Approval & Merge**: Maintainers review and approve. PRs are auto-merged after approval.
6. **Release**: Automated versioning and changelog for both Terraform and non-Terraform code.

See [Workflow Logic](docs/WORKFLOW_LOGIC.md) and [Main Validation SDLC Guide](docs/main-validation-sdlc.md) for full details.

## 🧑‍💻 Contribution Process

### For Terraform Code
- Follow [module structure requirements](docs/terraform-module-structure.md) and [module policies](docs/terraform-module-policies.md).
- Implement comprehensive tests using [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).
- Validate and test locally before submitting a PR.
- Use conventional commit messages (`feat:`, `fix:`, etc.).
- Automated validation, testing, and release via CI/CD.

### For Non-Terraform Code
- Linting, tests, and policy checks as appropriate.
- Uses `python-semantic-release` for versioning and changelog.
- Automated validation and release via CI/CD.

### Internal vs External Contributors
- **Internal**: Direct branch, push, and PR workflow. Tests run automatically.
- **External**: Fork, branch, PR workflow. Cannot modify workflows. Tests require manual approval.

See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for detailed instructions.

## 📚 Documentation

### Contributor Guides
- [Contributing Guidelines](docs/CONTRIBUTING.md) - How to contribute and SDLC process
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
