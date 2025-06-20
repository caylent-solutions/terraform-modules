# Terraform Modules Repository - Workflow Logic Flow

## 1. PR Validation Entry Point (`pr-validation.yml`)
**Trigger**: Pull request to `main` branch
**Purpose**: Route PRs to appropriate validation workflow

### Flow:
1. **Validate Job**
   - Checkout code with full history
   - **Simulate merge** to test compatibility
   - Install system dependencies + ASDF + tools
   - Install Go dependencies
   - Validate OPA policy syntax
   - Get changed files and update config
   - **Detect module changes** → Sets `IS_MODULE`, `MODULE_PATH`, `MODULE_TYPE`

2. **Route to Validation**
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
   - **Manual approval** from code owners
   - **Auto-merge** PR on approval

4. **Run Tests - External Contributors** (Depends: validate-module)
   - If contributor is external
   - Requires `external-contributor-test-approval` environment
   - Checkout code + **simulate merge** on `external-tests` branch
   - Run same tests as internal
   - Send Slack notification
   - **Manual approval** from code owners
   - **Auto-merge** PR on approval

5. **Post-Merge Validation** (Depends: successful merge)
   - Checkout main branch (no merge simulation needed)
   - Install system dependencies + ASDF + tools
   - Configure environment
   - Re-run all validation steps on merged code
   - Run module tests
   - Send Slack notification for QA approval

6. **QA Certification** (Depends: post-merge-validation)
   - **Manual QA approval** from code owners
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
   - **Manual approval** from code owners
   - **Auto-merge** PR on approval

3. **Post-Merge Validation** (Depends: validate-non-terraform)
   - Checkout main branch (no merge simulation needed)
   - Install system dependencies + ASDF + tools
   - Configure environment
   - Re-run all validation steps
   - Send Slack notification for QA approval

4. **QA Certification** (Depends: post-merge-validation)
   - **Manual QA approval** from code owners
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
- Manual approval received
- Contributor type verified

### Merge Simulation Strategy:
- **PR workflows**: Always simulate merge to test compatibility
- **Post-merge workflows**: Work directly on main branch
- **Release workflows**: Work directly on main branch
- **Health checks**: Work directly on main branch
- Each job uses unique branch names to avoid conflicts