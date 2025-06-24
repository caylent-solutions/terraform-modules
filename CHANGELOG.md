# CHANGELOG


## Unreleased

### Breaking

* feat: add validation summary job for consistent PR status checks (#4)

* feat: add validation summary job for consistent PR status checks

- Add &#39;Validation Complete&#39; job that runs after conditional validation workflows
- Ensures single required status check works for both Terraform and non-Terraform PRs
- Eliminates need to set multiple conditional workflows as required in branch protection
- Provides clear success/failure messaging based on PR type and validation results

* fix: resolve GitHub Actions workflow issues and add validation summary

- Fix git merge failures by using correct SHA references
  - Replace github.event.pull_request.head.sha with github.sha
  - Replace github.event.pull_request.base.sha with origin/base_ref
  - Affects all simulate merge steps across workflows

- Remove deprecated set-output commands from Go script
  - Eliminates GitHub Actions deprecation warnings
  - Workflow already handles output parsing correctly

- Fix API permission issues in contributor checks
  - Use context.payload instead of API calls where possible
  - Gracefully handle org membership check failures
  - Prevents 403 &#34;Resource not accessible by integration&#34; errors

- Remove if: always() conditions to enable fail-fast behavior
  - Steps now properly fail when dependencies fail
  - Prevents cascading errors from continuing execution

- Add validation-complete summary job to pr-validation workflow
  - Provides single required status check for branch protection
  - Works for both Terraform and non-Terraform PRs
  - Eliminates need for multiple conditional required checks

Fixes simulate merge, code owner detection, contributor identification,
and provides reliable status check for GitHub branch protection rules.

* fix: resolve workflow merge issues and enhance notifications

Git Merge Fixes:
- Fix simulate merge steps to use proper branch references
- Replace github.sha with origin/github.head_ref to avoid unrelated histories
- Add explicit fetch of PR branch before merge attempts
- Resolves &#34;fatal: refusing to merge unrelated histories&#34; errors

Slack Notification Enhancements:
- Add failure notifications to all workflow jobs (previously only success)
- Include contextual information (module path, contributor type, etc.)
- Add post-merge validation failure notifications
- Cover both terraform and non-terraform validation workflows

User Experience Improvements:
- Add visual feedback to module detection with ✅/❌ emojis
- Provide clear success/failure messages with context
- Show detected change type (terraform module vs non-terraform)
- Include actionable error messages for failed detections

Workflow Fixes:
- Fix git diff commands to use proper branch references
- Correct contributor check to handle API permission issues gracefully
- Remove deprecated set-output commands from Go detection script
- Add validation-complete summary job for unified status checks

Files changed:
- .github/workflows/pr-validation.yml
- .github/workflows/non-terraform-validation.yml
- .github/workflows/terraform-module-validation.yml
- scripts/detect-proposed-git-repo-changes/main.go

Ensures reliable workflow execution with comprehensive notifications
and clear user feedback for both success and failure scenarios.

* fix: resolve code owners detection by using correct git diff references

- Change git diff from comparing HEAD to using branch-to-branch comparison
- Use origin/base_ref...origin/head_ref syntax for accurate file detection
- Fixes issue where simulate merge caused empty CHANGED_FILES list
- Ensures code owners are properly identified for PR changes
- Applied to both terraform and non-terraform validation workflows

This resolves the &#34;No code owners found&#34; error by correctly identifying
changed files between the base branch and PR branch, regardless of the
current HEAD state after simulate merge operations.

* Remove fallback logic from GitHub Actions workflows

- Remove &#39;|| &#34;Unknown&#34;&#39; fallbacks from Slack notification author and code owner fields
- Enforce strict validation requiring explicit code owner patterns and contributor detection
- Workflows now fail completely if code owners cannot be determined or contributor type cannot be identified
- Keep legitimate fallbacks for Git operations (commit messages) and optional parameter formatting
- Ensures no placeholder values are displayed in notifications, enforcing proper data validation

Files modified:
- .github/workflows/non-terraform-validation.yml
- .github/workflows/terraform-module-validation.yml

* ci: fix CODEOWNERS location and Slack notification step dependencies

- Move CODEOWNERS from root to .github/ directory where workflows expect it
- Add &#39;if: always()&#39; to contributor check steps so they run even when codeowners step fails
- Remove fallback logic from PR URL in Slack notifications
- Ensure step outputs are available for failure notifications without using fallback values

This ensures strict validation without fallbacks while making required step outputs available for notifications.

* ci: implement GitHub App token for organization membership checks

- Add GitHub App token generation using GH_APP_ID and GH_APP_PRIVATE_KEY secrets
- Update permissions to include contents:write and id-token:write
- Remove fallback logic from contributor type detection - now fails if org membership cannot be determined
- Use tibdex/github-app-token@v2 action for consistent token generation across workflows
- Update both non-terraform-validation and terraform-module-validation workflows

This ensures strict validation without defaults - workflows fail if they cannot determine contributor type properly.

* ci: fix workflow permissions to match calling workflow constraints

- Change validation jobs from contents:write to contents:read since they only read code
- Keep contents:write only for jobs that perform actual merge operations:
  - validate-non-terraform (squash merges PRs)
  - run-tests-caylent (squash merges PRs)
  - run-tests-external (squash merges PRs)
- Retain id-token:write for GitHub App token generation
- Fixes workflow permission errors when called from pr-validation.yml

This ensures called workflows only request permissions they actually need.

* ci: add required permissions to calling workflow for GitHub App tokens

- Add id-token:write permission to allow called workflows to generate GitHub App tokens
- Add contents:write permission to allow merge operations in validation workflows
- Update both terraform-module-validation and non-terraform-validation job permissions

This fixes the workflow permission errors where called workflows were requesting more permissions than granted.

* ci: add debugging for GitHub App secrets availability

- Add debug step to check if GH_APP_ID and GH_APP_PRIVATE_KEY secrets are available
- This will help diagnose why the tibdex/github-app-token action is failing with &#39;app_id not supplied&#39;
- Temporary debugging that can be removed once issue is identified

* ci: fix secret passing to reusable workflows

- Add secrets declaration to reusable workflow definitions (terraform-module-validation and non-terraform-validation)
- Pass organization secrets (GH_APP_ID, GH_APP_PRIVATE_KEY, SLACK_WEBHOOK_URL) from calling workflow
- This fixes the &#39;app_id not supplied&#39; error from tibdex/github-app-token action

Reusable workflows require explicit secret declarations and passing, even for org-level secrets.

* ci: remove debug statements for secret availability

- Remove temporary debug steps that were checking GH_APP_ID and GH_APP_PRIVATE_KEY availability
- Debug statements are no longer needed since secret passing issue has been resolved
- Clean up workflows to remove unnecessary debugging output

* Fix manual approval permissions and environment setup

- Add environment: merge-approval for Caylent internal contributor tests
- Add environment: qa-certification for QA certification steps
- Add issues: write permission for manual approval jobs to create GitHub issues
- Replace github.TOKEN with GitHub App tokens for proper API permissions
- Ensure all manual approval steps use GitHub App tokens with repo access
- Fix token generation consistency across workflows

* Add issues: write permission to reusable workflow calls

- Grant issues: write permission to terraform-module-validation workflow
- Grant issues: write permission to non-terraform-validation workflow
- Fixes error: nested jobs requesting &#39;issues: write&#39; but only allowed &#39;issues: none&#39;
- Required for manual approval actions to create GitHub issues

* Restructure non-terraform workflow: move merge approval after validation

- Remove environment: merge-approval from validate-non-terraform job
- Create separate merge-approval job that runs after validation completes
- Environment gate now appears after all validation steps pass
- Update post-merge-validation to depend on merge-approval job
- Merge approval now happens at the correct stage in the workflow

* Restructure terraform module validation workflow: move merge approval after testing

- Remove environment gates from run-tests-caylent and run-tests-external jobs
- Create separate merge-approval-caylent and merge-approval-external jobs
- Environment gates now appear after all validation/testing completes successfully
- Update post-merge-validation to depend on merge approval jobs
- Remove unnecessary GitHub App token generation from test jobs
- Environment approval now happens at the correct stage in the workflow

Changes:
- merge-approval environment gate: after Caylent internal testing
- external-contributor-test-approval environment gate: after external testing
- Both gates now appear AFTER validation completes, not before

* 🔒 SECURITY FIX: Add pre-test approval gate for external contributors

CRITICAL SECURITY ISSUE RESOLVED:
- External contributors can no longer execute code without approval
- Added environment: external-contributor-test-approval to run-tests-external job
- This creates approval gate BEFORE tests run, not after
- Changed merge approval to use external-contributor-merge-approval environment

NEW FLOW FOR EXTERNAL CONTRIBUTORS:
Validate → 🔒 Pre-Test Approval → Run Tests → 🔒 Merge Approval → Post-Merge → QA

ENVIRONMENTS NEEDED:
- external-contributor-test-approval (for pre-test approval)
- external-contributor-merge-approval (for merge approval)

* Remove redundant pre-merge CodeQL analysis from reusable workflows

FIXES CodeQL warnings:
- Remove pre-merge-codeql jobs from both reusable workflows
- Resolves &#39;MissingPushHook&#39; warning for code scanning workflow
- Resolves &#39;Please specify an on.push hook&#39; issue

RATIONALE:
- Reusable workflows (workflow_call) cannot have push hooks
- Dedicated codeql-analysis.yml already handles push events to main branch
- Pre-merge CodeQL in reusable workflows was redundant and causing warnings
- CodeQL security alerts will still appear on Security tab via dedicated workflow

The existing codeql-analysis.yml workflow provides proper CodeQL coverage:
- Runs on push to main branch
- Contributes to Security tab
- No duplicate analysis needed in PR workflows

* Configure CodeQL to run on push to any branch

- Remove branch restriction from CodeQL workflow
- CodeQL will now run on pushes to all branches
- Provides continuous security scanning across all development branches
- Bot exclusion (caylent-platform-bot[bot]) still applies

* Implement comprehensive GitHub Actions security hardening

🔒 Security Enhancements:
- Block external contributors from modifying workflow files
- Add security check with strict contributor validation
- Require manual approval for external contributor workflows
- Add colorful emoji contributor detection logging

📱 Slack Improvements:
- Add repository information to all Slack notifications
- Include consistent contributor name and type in all messages
- Enhanced message formatting with repository context

🛡️ Workflow Hardening:
- Strict organization membership checks using GitHub App tokens
- No fallback logic for contributor detection
- Minimal permissions for validation jobs
- Separate approval gates for external vs internal contributors

This provides defense-in-depth against malicious external contributions while maintaining efficient workflows for internal development.

* Security: Harden GitHub Actions with SHA-pinning and automated allowlist management

- Hardened all GitHub Actions workflows by pinning third-party actions to commit SHAs:
  - tibdex/github-app-token@3beb63f4bd073e61482598c45c71c1019b59b73a  # v2
  - slackapi/slack-github-action@6c661ce58804a1a20f6dc5fbee7f0381b469e001  # v1.25.0
  - trstringer/manual-approval@9f5e5d6bc511762e17f849775a3c56bdea6b4493  # v1

- Created automated security management system:
  - Added security-scripts/action-security.py for dynamic action discovery
  - Automatically scans all workflow files for GitHub Actions
  - Generates GitHub Actions allowlist under 255-character limit
  - Provides copy/paste allowlist for GitHub repository settings

- Enhanced security documentation:
  - Updated CONTRIBUTING.md with GitHub Actions security section
  - Added event-driven security process (run after any workflow changes)
  - Updated README.md and docs/README.md with security references
  - Created comprehensive security-scripts/README.md

- Improved security workflow:
  - Changed from quarterly to event-driven updates
  - Automated third-party action discovery and SHA management
  - Simplified allowlist generation and GitHub settings updates

This prevents supply chain attacks by ensuring third-party actions cannot be modified maliciously through tag manipulation.

* Security: Update action-security.py to generate compact allowlist format

- Modified action-security.py to generate comma-separated, single-line allowlist
- Reduces character count from 222 to 221 characters
- Improves compatibility with GitHub Enterprise restrictions
- Maintains all security features while optimizing for allowlist format constraints

The compact format should resolve GitHub Enterprise issues with multi-line
allowlist formats and wildcard pattern recognition.

* docs: Update documentation to reflect current CI/CD workflows and security features

- Enhanced WORKFLOW_LOGIC.md with comprehensive security section covering:
  - GitHub Actions security (SHA-pinning, automated management, allowlist protection)
  - External contributor protection (workflow modification blocking, manual approvals)
  - Code security scanning (CodeQL integration)
  - Access control (GitHub App authentication, code owner enforcement)
  - Updated PR validation flow to include security-check job

- Updated CONTRIBUTOR_GUIDE.md with new security controls section:
  - GitHub Actions security management
  - External contributor protection measures
  - CodeQL analysis and vulnerability detection

- Enhanced README.md with expanded security governance:
  - Added comprehensive security section with 6-point security framework
  - Updated CI/CD pipeline description to reflect security-first approach
  - Renumbered workflow sections for clarity

- Updated docs/README.md with workflow and process section:
  - Added links to workflow logic and contributor guides
  - Better organization of documentation structure

- Enhanced .github/PULL_REQUEST_TEMPLATE.md:
  - Added security notice for external contributors
  - Included workflow modification restrictions
  - Added automated process explanation
  - Updated checklist with validation commands

All documentation now accurately reflects the current state of:
- SHA-pinned GitHub Actions for supply chain security
- External contributor workflow restrictions
- Automated security management via security-scripts/
- Multi-stage approval processes and environment isolation

* feat: Add make task for GitHub Actions security management

- Added &#39;make github-actions-security&#39; task to Makefile
  - Includes helpful instructions for updating GitHub settings
  - Positioned alphabetically between go-unit-test-coverage-json and help
  - Added to .PHONY declaration

- Updated all documentation to reference new make task:
  - security-scripts/README.md: Updated usage examples and process steps
  - CONTRIBUTING.md: Updated GitHub Actions security section
  - README.md: Updated security management references
  - CONTRIBUTOR_GUIDE.md: Updated automated management references
  - docs/WORKFLOW_LOGIC.md: Updated security management references

- Enhanced security-scripts/action-security.py:
  - Updated output messages to reference &#39;make github-actions-security&#39;
  - Improved user guidance for maintenance procedures

Benefits:
- Consistent interface: Users can now run &#39;make github-actions-security&#39;
- Better discoverability: Task appears in &#39;make help&#39; output
- Standardized workflow: Aligns with other repository automation tasks
- Clear instructions: Make task includes next steps for GitHub settings

The make task provides a unified entry point for GitHub Actions security
management while maintaining backward compatibility with direct script execution.

* feat: complete approval gate migration from manual approval to GitHub Environments

- Remove all trstringer/manual-approval actions from workflows
- Replace manual approval gates with GitHub Environment protection rules
- Remove unnecessary &#39;issues: write&#39; permissions from all workflow jobs
- Update workflows to use 4 GitHub Environments for approval gates:
  * external-contributor-test-approval: External contributor test execution
  * merge-approval: Internal contributor PR merges
  * external-contributor-merge-approval: External contributor PR merges
  * qa-certification: Final QA approval before release
- Update documentation to reflect new environment-based approval process
- Maintain SHA-pinned third-party actions for security
- Update GitHub Actions allowlist after permission cleanup

BREAKING CHANGE: Approval gates now require GitHub Environment setup
Repository administrators must configure the 4 required environments
with appropriate reviewers and protection rules for workflows to function.

This completes the security hardening initiative by removing all
issue-based manual approvals and migrating to GitHub&#39;s native
Environment protection system.

* fix: action permissons

* fix: add missing pull-requests: write permissions to PR merge jobs

- Add pull-requests: write permission to jobs that merge PRs via GitHub API
- Fix 403 &#39;Resource not accessible by integration&#39; errors in merge operations
- Apply to both terraform-module-validation.yml and non-terraform-validation.yml
- Maintain principle of least privilege:
  * Test-only jobs use contents: read (run-tests-external)
  * Merge jobs use contents: write + pull-requests: write
- Ensure all GitHub API pull merge operations have required permissions

Resolves GitHub API 403 errors when workflows attempt to merge PRs
after successful validation and approval.

* fix: add pull-requests write permission to reusable workflow calls

- Add pull-requests: write permission to terraform-module-validation job
- Add pull-requests: write permission to non-terraform-validation job
- Required for reusable workflows to merge PRs via github.rest.pulls.merge()
- Fixes workflow validation error about nested jobs requesting permissions

* refactor: improve job naming and optimize validation workflows

- Change job ID from &#39;validate-non-terraform&#39; to &#39;contributor-analysis&#39; for clarity
- Update all job references throughout non-terraform-validation.yml
- Rename terraform validation job to &#39;module-validation-and-routing&#39;
- Update all job references in terraform-module-validation.yml
- Remove unnecessary &#39;simulate merge&#39; step from contributor analysis jobs
- Add fetch-depth: 0 to checkout steps that need branch comparison
- Improve step names to be more descriptive of actual functionality
- Add explanatory comments to clarify job purposes

These jobs now have names that accurately reflect their function:
- contributor-analysis: Determines internal vs external contributor routing
- module-validation-and-routing: Validates terraform modules and routes workflow

* feat: add self-approval capability for authorized users

- Enhanced contributor analysis to check SELF_APPROVAL_USERS repository variable
- Added merge-self-approval jobs for internal contributors with self-approval privileges
- Updated merge-approval jobs to only run when self-approval is not available
- External contributors still require manual approval (no self-approval option)
- Added can-self-approve output to contributor analysis jobs
- Updated post-merge-validation dependencies to include self-approval jobs
- Improved Slack notifications to differentiate self-approved vs manually approved merges

Both terraform-module-validation.yml and non-terraform-validation.yml now support:
- Configurable self-approval via SELF_APPROVAL_USERS repository variable
- Consistent approval logic across both workflows
- Maintained security controls for external contributors

* fix: correct job name from contributor-analysis to terraform-and-contributor-analysis

- Updated job name to match user requirements
- Fixed all job references and dependencies
- Fixed all output references
- Resolves workflow validation errors in pr-validation.yml

* feat: implement admin bypass for self-approval merges and add validation-complete status

Self-Approval Admin Bypass:
- Updated self-approval merge steps to use GitHub CLI with --admin flag
- This bypasses repository branch protection rules requiring approval from non-pusher
- Uses GitHub App token with admin privileges for the merge operation
- Self-approval users (configured via SELF_APPROVAL_USERS) can now merge their own PRs

Validation Complete Status Check:
- Added &#39;validation-complete&#39; job to both workflows
- Provides required &#39;Validation Complete&#39; status check for branch protection
- Runs after all tests complete successfully
- Updated merge job dependencies to wait for validation-complete

Key Benefits:
- Self-approval users bypass branch protection with proper admin privileges
- Repository still gets required &#39;Validation Complete&#39; status check
- Maintains security for external contributors (no admin bypass)
- Clear audit trail showing admin bypass was used for authorized self-approvals

* feat: add orchestration status check jobs for unified validation gates

Added three key orchestration jobs to both workflows:

1. PR Validation Complete:
   - Consolidates terraform and non-terraform validation-complete jobs
   - Provides single required status check for PR branch protection
   - Runs after all validation tests but before merge approval

2. QA Validation Complete:
   - Consolidates terraform and non-terraform post-merge validation
   - Provides unified status check before release approval
   - Runs after post-merge revalidation but before qa-certification

3. Release Complete:
   - Final status check after all release processes complete
   - Indicates full release cycle completion
   - Runs after qa-certification (release approval)

These orchestration jobs will be configured in pr-validation.yml to:
- Wait for both terraform and non-terraform workflows to complete
- Provide single status checks for branch protection rules
- Create clear validation gates throughout the CI/CD pipeline

Status Check Hierarchy:
validation-complete → PR Validation Complete → merge approval
post-merge-validation → QA Validation Complete → release approval
qa-certification → Release Complete

* refactor: remove individual pr-validation-complete jobs for centralized approach

Removed individual &#39;pr-validation-complete&#39; jobs from both workflows to enable
a single consolidated PR Validation Complete status check.

Changes:
- Removed pr-validation-complete job from terraform-module-validation.yml
- Removed pr-validation-complete job from non-terraform-validation.yml
- Updated all merge approval jobs to depend directly on &#39;validation-complete&#39;
- Maintained qa-validation-complete and release-complete orchestration jobs

The consolidated &#39;PR Validation Complete&#39; status check will be implemented in
pr-validation.yml as a single job that waits for both:
- Terraform Validation / Validation Complete
- Non-Terraform Validation / Validation Complete

This provides the single required status check for PR branch protection rules
while maintaining the orchestration pattern for QA and Release gates.

* refactor: split PR validation workflows into distinct validation and approval phases

- Refactor pr-validation.yml to focus on change detection and testing only
- Create new main-validation.yml for merge approval, post-merge validation, and release
- Archive old workflows as .deprecated files with notices
- Implement clean separation of concerns between validation and approval
- Maintain all existing security controls and approval processes
- Preserve full functionality while improving maintainability and observability

Changes:
- pr-validation.yml: Complete refactor for validation/testing phase
- main-validation.yml: New workflow for approval/merge/release phase
- Archive: non-terraform-validation.yml → non-terraform-validation.yml.deprecated
- Archive: terraform-module-validation.yml → terraform-module-validation.yml.deprecated

The new structure provides better separation between:
1. PR Validation: Security checks, change detection, testing
2. Main Validation: Merge approval routing, post-merge validation, release approval

* fix: replace all GITHUB_TOKEN references with GitHub App authentication

- Updated pr-validation.yml to use GitHub App token (steps.generate_token.outputs.token) for workflow dispatch
- Updated main-validation.yml to use GitHub App tokens (steps.github-app-token.outputs.token) for all GitHub API operations in merge approval jobs
- All workflow authentication now uses GitHub App credentials (GH_APP_ID and GH_APP_PRIVATE_KEY secrets) instead of default GITHUB_TOKEN
- This resolves the &#39;Resource not accessible by integration&#39; error when triggering workflow dispatches
- GitHub App tokens provide the necessary permissions for cross-workflow triggering and PR merge operations

* fix: github app permission

* fix: actions: write

* Temp fix, till merge to main

* fix

* fix

* fix - 2

* fix-3

* fix-4

* fix-5 ([`8f81b90`](https://github.com/caylent-solutions/terraform-modules/commit/8f81b90ba6cd4a5d4729eff2a18210e59f5aff32))

### Feature

* feat: trigger bump ([`d58aa34`](https://github.com/caylent-solutions/terraform-modules/commit/d58aa34fd32729c31c5816f79a27111c062519dc))

* feat: trigger version bump (#12) ([`d003eed`](https://github.com/caylent-solutions/terraform-modules/commit/d003eed9d5e8b573e779f818156b75379093125d))

* feat: improve version detection and changelog generation (#10)

Self-approved squash merge by authorized user with admin privileges ([`d11ef97`](https://github.com/caylent-solutions/terraform-modules/commit/d11ef9744a2d7af6b2fc074962e6b37bbc830f47))

* feat: test-non-tf-change-cicd (#8)

Self-approved squash merge by authorized user with admin privileges ([`cdaf8db`](https://github.com/caylent-solutions/terraform-modules/commit/cdaf8db51cdc580f445adf29ad8990baf43ca867))

* feat: (main-validation) add dry run mode, module config parsing, and safe merge simulation (#7)

feat(main-validation): add dry run mode and improve routing flags

✨ Features
Added dryrun input to main-validation.yml (default: false)
Implemented dry run detection in all merge, approval, and release jobs
Added structured Slack messages to reflect dry run status
Enabled full end-to-end simulation without destructive actions
🔧 Changes
Replaced module_path and module_type inputs with JSON-formatted module_config
Extracted parse-module-config step for parsing module data
Added debug-routing-output job to expose routed values
Refactored conditional logic to use computed flags like is_terraform, can_self_approve_internal, etc.
Updated all gh pr merge and github-script calls to skip in dry run
Included conditional checkout for dry run (use branch instead of main)
Added Make targets: build-main-validation, test-main-validation-workflow, tf-clean
🧪 Post-Merge Validation
Added dry run routing control to post-merge jobs
All terraform validation steps (tf-lint, tf-format, etc.) use clean state via make tf-clean
Added module Go test bootstrap (make install, make go-lint, etc.)
📝 Docs &amp; Metadata
Updated README.md, CONTRIBUTING.md, and docs/WORKFLOW_LOGIC.md with dry run details
Created docs/main-validation-sdlc.md SDLC and workflow maintenance guide
Updated CHANGELOG.md for unreleased version
🧼 Cleanup
Removed terragrunt from .tool-versions (unused in validation)
Updated .PHONY with new Make targets ([`f7f2cd4`](https://github.com/caylent-solutions/terraform-modules/commit/f7f2cd4cc9cd9feb400408ba432983fc43c110e1))

* feat: 🚀 Implement Complete Terraform Monorepo OPA Policy Framework (#3)

🚀 Implement Complete Terraform Monorepo OPA Policy Framework

Introduce a comprehensive Open Policy Agent (OPA) framework for enforcing standards, quality, and governance across all Terraform modules in the monorepo. This includes 11,665+ lines of new functionality, full test coverage, and no breaking changes.

🎯 Key Features:
- 13 core Terraform module policies (structure, testing, quality)
- 4 module type-specific policies (primitive, collection, reference, utility)
- 2 global policies (license compliance, empty PR prevention)
- 1 cloud provider restriction policy (AWS-only)

🔧 Automation &amp; CI/CD:
- 8 GitHub Actions workflows (validation, release, health checks)
- 9 Go-based utilities for linting, formatting, testing, validation
- Semantic release with changelog generation
- Weekly module health monitoring

📚 Docs &amp; Standards:
- Policy and workflow documentation with remediation guidance
- Developer guides and module templates
- Contribution standards

🧪 Testing Infrastructure:
- 100+ OPA unit tests
- Test fixtures and Terratest integration
- Go test coverage for all scripts

📁 Key Components:
- `policies/opa/`: Core, type-specific, and global OPA policies
- `scripts/`: Tools for linting, formatting, validation, testing
- `.github/workflows/`: CI for validation, PRs, releases, monitoring
- `docs/`: Usage guides and standards

🛠️ Developer Experience:
- New Makefile targets: `go-lint`, `go-format`, `tf-docs`, `tf-plan`, `tf-security`, `test-all`
- Pre-commit hooks for formatting and validation
- IDE configuration and `.tool-versions` support

🔄 Migration:
- Fully backward compatible
- Incremental policy adoption supported
- Skeleton module updates for new development

📊 Impact:
- 139 files changed
- No breaking changes
- Fully tested and production ready

🎉 Benefits:
- Enforced consistency and structure
- Automated validation and compliance
- Scalable and maintainable module development

This lays the foundation for long-term governance, automation, and standardization of Terraform modules across the organization. ([`7da1a57`](https://github.com/caylent-solutions/terraform-modules/commit/7da1a573c3c8f8ce30e6fa05b2a36f04690ab5fd))

### Fix

* fix: test non tf pr with no main-validation.yml change (#6)

Self-approved squash merge by authorized user with admin privileges ([`b4ab195`](https://github.com/caylent-solutions/terraform-modules/commit/b4ab19502cf61421f1b04712d49e496cac4a8d4b))

### Unknown

* Auto PR from non-tf-bump-01 (#11)

feat: trigger non tf version bump ([`e991cf9`](https://github.com/caylent-solutions/terraform-modules/commit/e991cf96f4577e26cc80afb15b802acaa2a21bf7))

* Fix release cicd (#9)

Self-approved squash merge by authorized user with admin privileges ([`4340325`](https://github.com/caylent-solutions/terraform-modules/commit/43403253c0dd8cb7cf8ab99d16c79439df84c91a))

* temp: add main-validation.yml to main so it can be triggered ([`85a31fb`](https://github.com/caylent-solutions/terraform-modules/commit/85a31fb19e672db282b7252514d446cc19909f4f))

* temp: add main-validation.yml (#5)

temp: add main-validation.yml to main so it can be triggered ([`e5acd76`](https://github.com/caylent-solutions/terraform-modules/commit/e5acd76a2cfae82419e8323fc553c9dfe3e0706a))

* Updated Readme links (#2) ([`e2f3488`](https://github.com/caylent-solutions/terraform-modules/commit/e2f34883141c812c618e25542640054c70793a17))

* terraform-terratest-framework integration (#1)

* Add gitignore

* Added base directory structure

* feat: Update gitignore to block devcontainer aws profile map

* fix: fixed terratest tests for generic skeleton tf module

* Remove .gitmodules file

* fix: remove non agnostic make task for skeleton

* feat: moved assertions out of helper to common pkg in terraform-terratest-framework

* fix: consolidated common tests into 1 file called module_test.go; found tests data being cached causing broken test to pass; set make task to clean cache on ever test run; fixed broken test that where found

* fix: added python via asdf to .tool-versions

* ignore go file

* feat: update to terraform-terratest-framework v1.1.0 and improve make task

* stop tracking go.sum ([`5a79779`](https://github.com/caylent-solutions/terraform-modules/commit/5a79779251d147e0feee58a23f0825ce4d4772f3))

* Initial commit ([`f4b2f56`](https://github.com/caylent-solutions/terraform-modules/commit/f4b2f56fb7c91b143283120e6c121f3ab7e1157c))

