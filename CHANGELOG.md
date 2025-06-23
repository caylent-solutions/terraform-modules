# Changelog - Repository (Non-Terraform Changes)

All notable changes to the repository infrastructure, policies, and non-Terraform code will be documented in this file.

Individual Terraform modules maintain their own CHANGELOG.md files in their respective directories.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Dry Run Mode for main-validation.yml**: Comprehensive dry run functionality for safe testing of workflow changes
  - All validation and testing logic executes normally
  - Slack notifications include dry run indicators  
  - No actual PR merges or release triggers occur
  - Full end-to-end simulation capability
- **Main Validation SDLC Guide**: Complete Software Development Lifecycle documentation for workflow maintenance
  - Located at `docs/main-validation-sdlc.md`
  - Covers branching strategy, testing procedures, safety measures
  - Includes troubleshooting guide and best practices
- **Enhanced Workflow Documentation**: Updated workflow logic documentation with dry run capabilities
- **Contributor Guidelines**: Added workflow modification guidance with dry run testing requirements

### Changed
- **main-validation.yml**: Updated all merge and release jobs to support dry run mode
  - Added `dryrun` input parameter (boolean, default: false)
  - All destructive actions now check `dryrun != 'true'` condition
  - Enhanced Slack notifications with dry run status indicators
  - Improved job output propagation for consistent dry run behavior
- **Documentation Structure**: Enhanced organization of workflow and process documentation

## [v0.1.0] - Initial Release