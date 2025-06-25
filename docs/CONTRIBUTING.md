# Contributing to Terraform Modules

> **All contributions should be made using the Caylent Devcontainer and Caylent Devcontainer CLI.**
>
> Local development outside the devcontainer is not supported. See the [Caylent Devcontainer & CLI documentation](https://github.com/caylent-solutions/devcontainer) for setup and usage instructions.

This comprehensive guide explains the complete Software Development Life Cycle (SDLC) and contribution process for both Terraform and non-Terraform code in this repository. It covers workflow logic, security, and the CI/CD pipeline for all contributor types.

---

## Quick Start by Contributor Type

### Internal Contributors (Caylent Employees)
```bash
# 1. Clone and setup
git clone https://github.com/caylent-solutions/terraform-modules.git
cd terraform-modules
make install-tools && make configure

# 2. Create module
git checkout -b feature/my-module
cp -r skeletons/generic-skeleton providers/aws/primitives/my-module
# ... implement your module ...

# 3. Validate and test
make module-validate MODULE_PATH=providers/aws/primitives/my-module MODULE_TYPE=primitive
cd providers/aws/primitives/my-module && make test

# 4. Submit PR
git add . && git commit -m "feat: add my-module primitive"
git push origin feature/my-module
# Create PR via GitHub UI
```

### External Contributors
```bash
# 1. Fork and clone
# Fork via GitHub UI first
git clone https://github.com/YOUR-USERNAME/terraform-modules.git
cd terraform-modules
make install-tools && make configure

# 2. Create module
git checkout -b feature/my-module
cp -r skeletons/generic-skeleton providers/aws/primitives/my-module
# ... implement your module ...

# 3. Validate and test locally
make module-validate MODULE_PATH=providers/aws/primitives/my-module MODULE_TYPE=primitive
cd providers/aws/primitives/my-module && make test

# 4. Submit PR to upstream
git add . && git commit -m "feat: add my-module primitive"
git push origin feature/my-module
# Create PR from fork to upstream via GitHub UI
```

---

## Complete SDLC Flow

### 1. Development Phase
- Follow [module structure requirements](terraform-module-structure.md)
- Implement comprehensive tests using [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework)
- Use conventional commit messages (`feat:`, `fix:`, `docs:`, etc.)
- Validate locally before submitting

### 2. Pull Request Submission
- **PR Detection**: System detects Terraform module vs non-Terraform changes
- **Security Scanning**: CodeQL analysis starts immediately (parallel to validation)
- **Validation**: Comprehensive policy and quality checks

### 3. Testing Phase
- **Internal Contributors**: Tests execute automatically after validation
- **External Contributors**: Tests require manual approval from Caylent maintainer for security

### 4. Review and Approval
- Slack notifications sent to code owners
- Code owners review and must explicitly approve before merge

### 5. Merge Process
- System automatically merges PR after approval (squash merge)
- Feature branch deleted automatically

### 6. Post-Merge Validation
- All validation checks re-run on merged code
- Additional security scanning on main branch

### 7. Release Preparation
- Manual QA certification required from code owners
- Authorizes semantic version release

### 8. Automated Release
- **Terraform Modules**: Individual semantic versioning per module
- **Non-Terraform**: Repository-wide semantic versioning
- Automatic changelog generation and GitHub release creation

---

## Key Differences by Contributor Type

| Aspect | Internal Contributors | External Contributors |
|--------|----------------------|----------------------|
| Repository Access | Direct clone | Fork required |
| Test Execution | Automatic | Manual approval required |
| Security Review | Streamlined | Enhanced scrutiny |
| Environment | Standard CI | Protected environment |
| Approval Speed | Faster | Additional security gates |

---

## CI/CD Workflows Overview

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

See [WORKFLOW_LOGIC.md](WORKFLOW_LOGIC.md) and [main-validation-sdlc.md](main-validation-sdlc.md) for full details.

---

## Terraform and Module Strategy

This monorepo manages all stateful resources (cloud, SaaS, Kubernetes, etc.) using a strict Terraform module strategy:

- **Module Types:**
  - **Primitive Modules:** Manage a single resource type. Must be agnostic, use official providers, and follow the latest skeleton and repo policies.
  - **Utility Modules:** Add opinionated functionality (e.g., naming/tagging). No resource blocks. Must be agnostic and live in this monorepo.
  - **Reference Modules:** Collections of primitives/utilities providing a reference architecture or service. Must be agnostic and tested for integration.
  - **Client Wrapper Modules:** Client-specific wrappers that import reference modules and add custom logic. Must live in the client’s repo and follow the same structure/testing standards.

- **General Requirements:**
  - All modules must use the latest skeleton, pass all OPA policies, and be fully tested (rego and Terratest).
  - All modules must be semantically versioned and released via CI/CD.
  - Use Apache 2.0 license unless client-specific.

- **Provider Strategy:**
  - Always use the latest stable official provider.
  - If a required feature/bugfix is missing, fork the provider, follow best practices for forking, and upstream changes when possible. See below for the provider forking workflow.

- **Terragrunt Usage:**
  - Terragrunt may be used in downstream consumer repos for orchestration, but all Terraform logic must reside in this monorepo.

- **Self-Contained and Single Purpose:**
  - Every module must be self-contained and focused on a single responsibility, supporting the [Self-Contained Repository Deployment Principle](principles/self-contained-repository-deployment-principle.md) and [Single Purpose Repository Principle](principles/single-purpose-repository-principle.md).

## Provider Forking Workflow

If you must fork a provider:
1. Fork the latest provider and add your feature/bugfix.
2. Ensure full testing and no regressions.
3. Use the fork in your module and deliver to production.
4. Create a tech debt story to upstream your change.
5. Refactor to use the official provider once merged.
6. If frequent changes are needed, manage your fork with a full pipeline and regular merges from upstream.

---

## Module Types and Structure

This repository contains different types of Terraform modules:
- **Primitives**: Basic building blocks that manage a single AWS resource
- **Collections**: Combinations of primitives that solve common use cases
- **References**: Reference implementations for specific scenarios
- **Utilities**: Helper modules for common tasks
- **Skeletons**: Template modules for creating new modules

All modules must follow the [required structure](terraform-module-structure.md) and [policies](terraform-module-policies.md).

---

## Development Guidelines
- No hard-coded values in Terraform code
- Variables must be declared in variables.tf
- Outputs must be declared in outputs.tf
- Provider configurations must be in versions.tf
- Local variables must be in locals.tf
- Write tests for all examples using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework)
- Ensure tests validate the module's core functionality
- Include common tests for validation, formatting, and outputs
- Create example-specific tests for unique features
- Follow the [test structure requirements](terraform-module-testing.md)
- Configure test behavior using the `test.config` file in the module root
- Control idempotency testing with `TERRATEST_IDEMPOTENCY=true|false` in the config file
- All Go test files must pass linting (`make go-lint`)
- All Go test files must be properly formatted (`make go-format`)

---

## Security Measures

### For All Contributors
- **Pre-merge CodeQL scanning**: Security vulnerability detection
- **Policy validation**: Automated governance enforcement
- **Code owner approval**: Human review required
- **Post-merge validation**: Additional quality checks

### Additional for External Contributors
- **Manual test approval**: Prevents malicious code execution
- **Environment isolation**: Protected CI environment
- **Enhanced review**: Additional security scrutiny

### GitHub Actions Security
- **SHA-Pinned Actions**: All third-party GitHub Actions are pinned to specific commit SHAs
- **Automated Management**: `make github-actions-security` manages action security
- **Allowlist Protection**: GitHub repository configured with action allowlist
- **Supply Chain Protection**: Prevents malicious updates to third-party actions

### External Contributor Protection
- **Workflow Modification Block**: External contributors cannot modify `.github/workflows/` files
- **Manual Test Approval**: Tests for external contributors require manual approval
- **Environment Isolation**: External tests run in protected environments
- **Token Limitations**: Limited GitHub token permissions for external contributions

### Code Security
- **CodeQL Analysis**: Automated security scanning runs on all PRs
- **Pre-Merge Scanning**: Security analysis completes before merge approval
- **Vulnerability Detection**: Blocks merge if security vulnerabilities are found

---

## Monitoring and Maintenance

### Continuous Monitoring
- **Weekly health checks**: All modules tested automatically
- **Security scanning**: Ongoing vulnerability detection
- **Quality metrics**: Test coverage and code quality tracking

### Release Management
- **Semantic versioning**: Automatic version determination
- **Changelog generation**: Automated from commit messages
- **Release notifications**: Team alerts for all releases
- **Audit trail**: Complete history of all changes

---

## Getting Help

### Documentation
- [Module Structure](terraform-module-structure.md)
- [Module Policies](terraform-module-policies.md)
- [Testing Requirements](terraform-module-testing.md)
- [Complete Workflow Logic](WORKFLOW_LOGIC.md)
- [Main Validation SDLC Guide](main-validation-sdlc.md)

### Support Channels
- **Issues**: Create GitHub issues for bugs or questions
- **Discussions**: Use GitHub Discussions for general questions
- **Direct Contact**: Reach out to repository maintainers

### Common Issues
- **Test failures**: Check local validation first
- **Policy violations**: Review module structure requirements
- **Approval delays**: Ensure code owners are correctly identified
- **External contributor delays**: Security review may take additional time

---

## Additional Notes

- **Workflow Maintenance:** For changes to workflow files (e.g., `.github/workflows/main-validation.yml`), follow the [Main Validation SDLC Guide](main-validation-sdlc.md) and always use dry run mode for safe testing.
- **CI/CD Details:** See [Workflow Logic](WORKFLOW_LOGIC.md) for a detailed explanation of all automated workflows and their routing logic.
- **Module and Non-Module Contributions:** Both Terraform and non-Terraform code follow the same high-level SDLC, with differences in validation and release as described above.

## How to Contribute

### For External Contributors

External contributors must use the fork and pull request workflow:

1. **Fork the Repository**:
   - Fork the repository to your GitHub account
   - Clone your fork locally: `git clone https://github.com/YOUR-USERNAME/terraform-modules.git`

2. **Create a Branch**:
   - Create a branch for your changes: `git checkout -b feature/your-feature-name`

3. **Make Your Changes**:
   - Follow the [module structure requirements](docs/terraform-module-structure.md)
   - Ensure your module adheres to all [module policies](docs/terraform-module-policies.md)
   - Write tests for your module following the required test structure
   - **Install module dependencies:**
     - From your module directory: `make install`
   - **Format and lint Go code in your module:**
     - `make go-format` and `make go-lint`
   - **Generate and check Terraform documentation:**
     - `make tf-docs` (generate docs)
     - `make tf-docs-check` (verify docs are up to date)
   - **Clean up module files:**
     - `make clean` (removes Terraform and state files)
     - `make clean-all` (also cleans Go cache)

4. **Validate Your Changes Locally**:
   - Install tools (from repo root): `make install-tools`
   - Run validation (from repo root): `make module-validate MODULE_PATH=your/module/path MODULE_TYPE=<module_type>`
   - Test locally (from module dir): `make test` (all tests), `make test-common` (common tests)

### For Caylent Contributors (Internal)

Internal contributors have direct repository access with streamlined workflow:

1. **Clone the Repository**:
   - Clone directly: `git clone https://github.com/caylent-solutions/terraform-modules.git`

2. **Create a Branch**:
   - Create a feature branch: `git checkout -b feature/your-module-name`

3. **Create Your Module**:
   - Start from skeleton: `cp -r skeletons/generic-skeleton providers/aws/primitives/your-module-name`
   - Follow the [module structure requirements](docs/terraform-module-structure.md)
   - Implement your module functionality
   - Create examples and tests
   - **Install module dependencies:**
     - From your module directory: `make install`
   - **Format and lint Go code in your module:**
     - `make go-format` and `make go-lint`
   - **Generate and check Terraform documentation:**
     - `make tf-docs` (generate docs)
     - `make tf-docs-check` (verify docs are up to date)
   - **Clean up module files:**
     - `make clean` (removes Terraform and state files)
     - `make clean-all` (also cleans Go cache)

4. **Validate Your Module**:
   - Run validation (from repo root): `make module-validate MODULE_PATH=providers/aws/primitives/your-module-name MODULE_TYPE=primitive`
   - Run tests (from module dir): `make test` (all tests), `make test-common` (common tests)
