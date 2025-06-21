# Terraform Modules Repository - Workflow Logic Flow

## 1. PR Validation Entry Point (`pr-validation.yml`)
**Trigger**: Pull request to `main` branch
**Purpose**: Route PRs to appropriate validation workflow and enforce security controls

### Flow:
1. **Security Check Job** (First Gate - Runs for all PRs except bot PRs)
   - Generate GitHub App token for elevated permissions
   - Checkout code with full history
   - Check contributor type (Internal Caylent employee vs External contributor)
   - **Security Control**: Block external contributors from modifying workflow files
   - If external contributor modifies `.github/workflows/` files → **FAIL PR**
   - If internal contributor → Allow workflow modifications

2. **Validate Job** (Runs in parallel with security check)
   - Checkout code with full history
   - **Simulate merge** to test compatibility
   - Install system dependencies + ASDF + tools
   - Install Go dependencies
   - Validate OPA policy syntax
   - Get changed files and update config
   - **Detect module changes** → Sets `IS_MODULE`, `MODULE_PATH`, `MODULE_TYPE`

3. **Route to Validation** (Depends on validate job)
   - If `IS_MODULE=true` → Call `terraform-module-validation.yml`
   - If `IS_MODULE=false` → Call `non-terraform-validation.yml`

---

## 2. Terraform Module Validation (`terraform-module-validation.yml`)
**Trigger**: Called from PR validation with module path/type
**Purpose**: Validate, test, and merge Terraform modules

### Flow:
1. **Pre-Merge CodeQL** (Security Gate - Runs in Parallel)
   - Checkout code
   - **Simulate merge** on `codeql-validation` branch
   - Initialize CodeQL for Go
   - Perform security analysis

2. **Validate Module** (Runs in Parallel with CodeQL)
   - Checkout code
   - **Simulate merge** on `module-validation` branch
   - Install system dependencies + ASDF + tools
   - Configure environment
   - Run module validation against policies
   - Run Terraform: lint, format check, docs check, security, plan
   - Run Go: lint and format check on module tests
   - Check contributor type (Internal/External)
   - Find code owners from CODEOWNERS file

3. **Run Tests - Internal Contributors** (Depends: validate-module)
   - If contributor is Caylent employee
   - Checkout code + **simulate merge** on `caylent-tests` branch
   - Run Terraform tests
   - Send Slack notification for review
   - **Environment approval** from `merge-approval` environment (GitHub Environment protection)
   - **Auto-merge** PR on approval

4. **Run Tests - External Contributors** (Depends: validate-module)
   - If contributor is external
   - Requires `external-contributor-test-approval` environment (GitHub Environment protection)
   - Checkout code + **simulate merge** on `external-tests` branch
   - Run same tests as internal
   - Send Slack notification
   - **Environment approval** required from protected reviewers
   - **Auto-merge** PR on approval (using `external-contributor-merge-approval` environment)

5. **Post-Merge Validation** (Depends: successful merge)
   - Checkout main branch (no merge simulation needed)
   - Install system dependencies + ASDF + tools
   - Configure environment
   - Re-run all validation steps on merged code
   - Run module tests
   - Send Slack notification for QA approval

6. **QA Certification** (Depends: post-merge-validation)
   - **Environment approval** from `qa-certification` environment (GitHub Environment protection)
   - **Trigger release workflow** with module details

---

## 3. Non-Terraform Validation (`non-terraform-validation.yml`)
**Trigger**: Called from PR validation for non-module changes
**Purpose**: Validate, test, and merge non-Terraform code

### Flow:
1. **Pre-Merge CodeQL** (Security Gate - Runs in Parallel)
   - Checkout code
   - **Simulate merge** on `codeql-validation` branch
   - Initialize CodeQL for Go
   - Perform security analysis

2. **Validate Non-Terraform** (Runs in Parallel with CodeQL)
   - Checkout code
   - **Simulate merge** on `non-terraform-validation` branch
   - Install system dependencies + ASDF + tools
   - Configure environment
   - Run Go: lint, format, unit tests, coverage
   - Run Rego: lint, format, unit tests, coverage (95% threshold)
   - Run Rego integration tests
   - Find code owners
   - Check contributor type
   - Send Slack notification
   - **Environment approval** from `merge-approval` environment (GitHub Environment protection)
   - **Auto-merge** PR on approval

3. **Post-Merge Validation** (Depends: validate-non-terraform)
   - Checkout main branch (no merge simulation needed)
   - Install system dependencies + ASDF + tools
   - Configure environment
   - Re-run all validation steps
   - Send Slack notification for QA approval

4. **QA Certification** (Depends: post-merge-validation)
   - **Environment approval** from `qa-certification` environment (GitHub Environment protection)
   - **Trigger release workflow** for non-terraform release

---

## 4. Standalone CodeQL Analysis (`codeql-analysis.yml`)
**Trigger**: Push to main only
**Purpose**: Scan actual merged code on main branch (complements PR pre-merge scans)

### Flow:
- Skip if actor is bot
- Checkout repository (no merge simulation - scans actual main branch)
- Initialize CodeQL for Go
- Perform analysis and upload results to Security tab

**Note**: This is NOT redundant - PR CodeQL scans test simulated merges, this scans the actual merged code

---

## 5. Release Workflow (`release.yml`)
**Trigger**: Manual dispatch OR triggered by QA certification
**Purpose**: Create semantic versioned releases

### Inputs:
- `release_type`: "terraform-module" or "non-terraform"
- `module_path`: Path to module (terraform only)
- `module_type`: Type of module (terraform only)
- `contributor_type`: "Internal" or "External"
- `contributor_username`: GitHub username

### Flow:
1. **Setup Environment**
   - Checkout code (no merge simulation - working on main)
   - Install dependencies + tools
   - Generate GitHub App token

2. **Version Determination**
   - For terraform modules: Use module-specific semantic versioning
   - For non-terraform: Use repo-wide semantic versioning
   - Analyze commit history with semantic-release
   - Generate next version number

3. **Release Creation**
   - Generate changelog
   - Create and push Git tag
   - Create GitHub release
   - Send Slack notification

---

## 6. Weekly Health Check (`weekly-module-health-check.yml`)
**Trigger**: Cron (Sunday 1AM UTC) OR manual dispatch
**Purpose**: Validate all modules remain healthy

### Flow:
- Checkout code (no merge simulation - testing main branch)
- Install system dependencies + ASDF + tools
- Configure environment
- Run `test-all-terraform-modules` make target
- Tests all modules in parallel (docs, format, lint, validate, plan, security, test)

---

## Key Decision Points

### Module Detection Logic:
- Analyzes changed files in PR
- Determines if changes affect Terraform modules
- Sets routing variables for validation workflow

### Contributor Type Logic:
- Checks GitHub org membership for 'caylent-solutions'
- Internal contributors: Auto-proceed after validation
- External contributors: Require environment approval

### Code Ownership Logic:
- Parses `.github/CODEOWNERS` file
- Matches changed files to ownership patterns
- Determines required approvers for manual approval steps

### Security Gates:
- **Pre-merge CodeQL**: Required before any validation (runs in parallel)
- **Manual approvals**: Required before merge and release
- **Post-merge validation**: Ensures merge didn't break anything
- **QA certification**: Final gate before release

### Auto-Merge Conditions:
- All validation tests pass
- Security scans complete
- Environment approval received (via GitHub Environment protection rules)
- Contributor type verified

### GitHub Environment Protection Rules:
The workflows use GitHub Environments for approval gates instead of issue-based manual approvals:

1. **`merge-approval`**: Used for approving internal contributor PR merges
   - Requires protected reviewers to approve before merge
   - Applied to both terraform-module and non-terraform internal contributor flows

2. **`external-contributor-test-approval`**: Used for approving external contributor test execution
   - Requires protected reviewers to approve before running tests on external PRs
   - Security gate to prevent malicious code execution

3. **`external-contributor-merge-approval`**: Used for approving external contributor PR merges
   - Requires protected reviewers to approve after tests pass
   - Final gate before merging external contributor changes

4. **`qa-certification`**: Used for final QA approval before release
   - Requires QA team approval before triggering release workflow
   - Applied to both terraform-module and non-terraform flows

### Merge Simulation Strategy:
- **PR workflows**: Always simulate merge to test compatibility
- **Post-merge workflows**: Work directly on main branch
- **Release workflows**: Work directly on main branch
- **Health checks**: Work directly on main branch
- Each job uses unique branch names to avoid conflicts

## Key Security Features Across All Workflows

### 1. **GitHub Actions Security**
- **SHA-Pinned Actions**: All third-party actions use commit SHAs instead of version tags
- **Automated Security Management**: `make github-actions-security` discovers and manages action security
- **Allowlist Generation**: Automatically generates GitHub Actions allowlist under 255-character limit
- **Protected Actions**: Only pre-approved actions can be used in workflows

### 2. **External Contributor Protection**
- **Workflow Modification Block**: External contributors cannot modify `.github/workflows/` files
- **Manual Test Approval**: External contributor tests require manual approval before execution
- **Environment Isolation**: External tests run in protected `external-contributor-test-approval` environment
- **Token Scoping**: Limited GitHub token permissions for external contributors

### 3. **Code Security Scanning**
- **Pre-Merge CodeQL**: Security analysis runs in parallel with validation on simulated merge
- **Comprehensive Coverage**: Scans Go code for security vulnerabilities
- **Integration**: CodeQL results block merge if security issues are found

### 4. **Access Control**
- **GitHub App Authentication**: Uses GitHub App tokens instead of personal access tokens
- **Code Owner Enforcement**: CODEOWNERS file controls who can approve changes
- **Multi-Stage Approval**: Separate validation, testing, and QA approval gates