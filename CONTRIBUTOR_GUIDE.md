# Contributor Guide - SDLC Process

This guide explains the complete Software Development Life Cycle (SDLC) process for contributing to the Terraform Modules repository.

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

## Complete SDLC Flow

### 1. Development Phase

**For All Contributors:**
- Follow [module structure requirements](docs/terraform-module-structure.md)
- Implement comprehensive tests using [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework)
- Use conventional commit messages (`feat:`, `fix:`, `docs:`, etc.)
- Validate locally before submitting

### 2. Pull Request Submission

**Automated Process Begins:**
1. **PR Detection**: System detects Terraform module vs non-Terraform changes
2. **Security Scanning**: CodeQL analysis starts immediately (parallel to validation)
3. **Validation**: Comprehensive policy and quality checks

### 3. Testing Phase

**Internal Contributors:**
- Tests execute automatically after validation
- No manual intervention required
- Full test suite runs in CI environment

**External Contributors:**
- Tests require manual approval from Caylent maintainer
- Security measure to prevent malicious code execution
- Maintainer reviews code before approving test execution
- After approval, full automated test suite runs

### 4. Review and Approval

**Automated Notifications:**
- Slack notifications sent to code owners
- PR marked as ready for review
- Code owners identified from `.github/CODEOWNERS`

**Manual Review Process:**
- Code owners review changes
- May request modifications
- Must explicitly approve before merge

### 5. Merge Process

**Automated Merge:**
- System automatically merges PR after approval
- Uses squash merge strategy
- Deletes feature branch automatically

### 6. Post-Merge Validation

**Quality Assurance:**
- All validation checks re-run on merged code
- Ensures merge didn't introduce issues
- Additional security scanning on main branch

### 7. Release Preparation

**QA Certification:**
- Manual approval required from code owners
- Certifies code quality and readiness for release
- Authorizes semantic version release

### 8. Automated Release

**Version Management:**
- **Terraform Modules**: Individual semantic versioning per module
- **Non-Terraform**: Repository-wide semantic versioning
- Automatic changelog generation
- GitHub release creation
- Slack notifications to team

## Key Differences by Contributor Type

| Aspect | Internal Contributors | External Contributors |
|--------|----------------------|----------------------|
| Repository Access | Direct clone | Fork required |
| Test Execution | Automatic | Manual approval required |
| Security Review | Streamlined | Enhanced scrutiny |
| Environment | Standard CI | Protected environment |
| Approval Speed | Faster | Additional security gates |

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

## Security Controls

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

## Getting Help

### Documentation
- [Module Structure](docs/terraform-module-structure.md)
- [Module Policies](docs/terraform-module-policies.md)
- [Testing Requirements](docs/terraform-module-testing.md)
- [Complete Workflow Logic](docs/workflow-logic.md)

### Support Channels
- **Issues**: Create GitHub issues for bugs or questions
- **Discussions**: Use GitHub Discussions for general questions
- **Direct Contact**: Reach out to repository maintainers

### Common Issues
- **Test failures**: Check local validation first
- **Policy violations**: Review module structure requirements
- **Approval delays**: Ensure code owners are correctly identified
- **External contributor delays**: Security review may take additional time