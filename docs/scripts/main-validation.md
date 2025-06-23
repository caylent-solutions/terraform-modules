# Main Validation Script

The `main-validation` script is a Go-based testing tool that triggers all 6 merge approval job variations in the `main-validation.yml` GitHub Actions workflow for comprehensive end-to-end testing.

## Purpose

This script enables developers and maintainers to test the complete `main-validation.yml` workflow by triggering all possible merge approval scenarios in dry run mode. It's essential for:

- **Workflow Development**: Testing changes to the main validation workflow before deploying to production
- **End-to-End Validation**: Ensuring all 6 approval job variations work correctly
- **Regression Testing**: Verifying that workflow changes don't break existing functionality
- **CI/CD Testing**: Validating that manual approval processes work as expected

## Location

- **Script**: `scripts/main-validation/main.go`
- **Binary**: `bin/main-validation` (created by `make build-main-validation`)
- **Configuration**: All parameters sourced from `monorepo-config.json`

## Features

### Configuration-Driven
- **Zero hardcoded values** - all configuration loaded from `monorepo-config.json`
- **Dynamic module detection** - automatically uses the correct test module and type
- **Branch-aware** - detects current git branch for workflow dispatch
- **Environment validation** - checks for required tools and authentication

### Comprehensive Testing
Triggers all 6 merge approval job variations:

1. **Internal-NonTerraform-SelfApproval**: Internal contributor, non-terraform changes, self-approval enabled
2. **Internal-NonTerraform-ManualApproval**: Internal contributor, non-terraform changes, manual approval required
3. **External-NonTerraform-ManualApproval**: External contributor, non-terraform changes (always manual approval)
4. **Internal-Terraform-SelfApproval**: Internal contributor, terraform changes, self-approval enabled
5. **Internal-Terraform-ManualApproval**: Internal contributor, terraform changes, manual approval required
6. **External-Terraform-ManualApproval**: External contributor, terraform changes (always manual approval)

### Safety Features
- **Dry run mode by default** - all workflows run in safe simulation mode
- **Manual confirmation** - requires Enter key before triggering workflows
- **Clear output** - detailed logging and progress indicators
- **Error handling** - strict validation with helpful error messages

## Configuration

The script reads all configuration from the `workflow_tests` section in `monorepo-config.json`:

```json
{
  "workflow_tests": {
    "test_module": "skeletons/generic-skeleton",
    "test_module_type": "skeleton", 
    "repository": "caylent-solutions/terraform-modules",
    "default_inputs": {
      "code_owners": "matt-dresden-caylent",
      "dryrun": "true"
    },
    "variations": [
      {
        "name": "Internal-NonTerraform-SelfApproval",
        "change_type": "non-terraform",
        "contributor_type": "Internal", 
        "can_self_approve": "true",
        "description": "Internal contributor making non-terraform changes with self-approval permissions"
      }
      // ... 5 more variations
    ]
  }
}
```

### Required Configuration Fields

- `test_module`: Path to the test module (e.g., "skeletons/generic-skeleton")
- `test_module_type`: Type of the test module (must exist in `module_types`)
- `repository`: GitHub repository in "owner/repo" format
- `default_inputs`: Map of default workflow inputs
- `variations`: Array of test variations with required fields:
  - `name`: Unique variation name
  - `change_type`: "terraform" or "non-terraform"
  - `contributor_type`: "Internal" or "External"
  - `can_self_approve`: "true" or "false"
  - `description`: Human-readable description

## Prerequisites

### Required Tools
- **Git**: Must be in a git repository with current branch detection
- **GitHub CLI**: Must be installed and authenticated (`gh auth login`)
- **Go**: For building the script (handled by make tasks)

### GitHub Authentication
The script requires GitHub CLI authentication:

```bash
# Check authentication status
gh auth status

# Login if needed
gh auth login
```

### Environment
- Must be run from the root of the terraform-modules repository
- Must have access to trigger GitHub Actions workflows on the target repository

## Usage

### Via Make Task (Recommended)
```bash
# Build and run the script
make test-main-validation-workflow
```

### Manual Usage
```bash
# Build the binary
make build-main-validation

# Run the binary directly
./bin/main-validation
```

### Development Usage
```bash
# Run directly with Go (for development)
cd scripts/main-validation
go run main.go
```

## Execution Flow

1. **Validation Phase**:
   - Load and validate configuration from `monorepo-config.json`
   - Check required tools (git, gh) availability
   - Verify GitHub CLI authentication
   - Validate test module exists and module type is defined
   - Detect current git branch

2. **Confirmation Phase**:
   - Display summary of all variations to be triggered
   - Show current branch and dry run status
   - Wait for user confirmation (Enter key)

3. **Execution Phase**:
   - Generate unique timestamp for test identification
   - Trigger each variation via `gh workflow run`
   - Use current branch for workflow dispatch (`--ref`)
   - Generate unique test identifiers for each run
   - Display progress and results

4. **Results Phase**:
   - Show summary of successful/failed triggers
   - Provide next steps for manual approval in GitHub UI
   - Display links to GitHub Actions for monitoring

## Output Example

```
=== Triggering All 6 Merge Approval Job Variations ===

📦 Using test module: skeletons/generic-skeleton (type: skeleton)
🏢 Repository: caylent-solutions/terraform-modules
✅ GitHub CLI is available and authenticated
📍 Current branch: feature/validation-improvements

This script will trigger all 6 variations in dry run mode.
Each will require manual approval in the GitHub UI.
Workflows will be triggered on branch: feature/validation-improvements
Press Enter to continue or Ctrl+C to cancel...

=== Triggering: Internal-NonTerraform-SelfApproval ===
Description: Internal contributor making non-terraform changes with self-approval permissions
Inputs: change_type=non-terraform, contributor_type=Internal, can_self_approve=true
Running gh workflow run command...
✅ Successfully triggered: Internal-NonTerraform-SelfApproval
Check GitHub Actions UI for manual approval

🎉 Triggered 6 out of 6 variations!

=== Next Steps ===
1. Go to GitHub Actions: https://github.com/caylent-solutions/terraform-modules/actions
2. You should see 6 new 'Main Validation' workflow runs
3. Each run will have jobs waiting for manual approval
4. Click on each workflow run to see the approval requirements
5. Look for jobs with '🟡 Waiting' status - these need manual approval
6. Click 'Review deployments' to approve each merge and release operation
```

## Testing and Validation

### Dry Run Mode
All workflows are triggered in dry run mode by default:
- ✅ Complete workflow logic execution
- ✅ Slack notifications (with dry run indicators)
- ✅ Environment protection rules tested
- 🚫 No actual PR merges
- 🚫 No release workflows triggered

### Manual Approval Testing
Each triggered workflow will require manual approval in the GitHub UI:
- Navigate to GitHub Actions → Main Validation workflows
- Look for workflows with "🟡 Waiting" status
- Click "Review deployments" to approve protected environment steps
- Verify correct routing and job selection for each variation

### Expected Jobs
Each variation should trigger the corresponding job in `main-validation.yml`:
- `merge-self-approval-non-terraform-internal`
- `merge-approval-non-terraform-internal`
- `merge-approval-non-terraform-external`
- `merge-self-approval-terraform-internal`
- `merge-approval-terraform-internal`
- `merge-approval-terraform-external`

## Error Handling

The script provides detailed error messages for common issues:

### Configuration Errors
```
❌ ERROR: Missing 'workflow_tests' configuration in monorepo-config.json
Please add a 'workflow_tests' section with the following required fields:
  - test_module: path to the test module (e.g., 'skeletons/generic-skeleton')
  - test_module_type: type of the test module (e.g., 'skeleton')
  - repository: GitHub repository (e.g., 'owner/repo')
  - default_inputs: map of default workflow inputs
  - variations: array of test variations
```

### Tool Availability Errors
```
❌ ERROR: GitHub CLI (gh) is not available
Please install GitHub CLI: https://cli.github.com/
```

### Authentication Errors
```
❌ ERROR: GitHub CLI authentication failed
Please authenticate with GitHub CLI using: gh auth login
```

### Module Validation Errors
```
❌ ERROR: Test module 'skeletons/generic-skeleton' does not exist
Please ensure the test module path is correct and the directory exists
```

## Integration with CI/CD

This script is integrated into the repository's development workflow:

1. **Workflow Development**: Developers use this script to test workflow changes
2. **Make Task Integration**: Available via `make test-main-validation-workflow`
3. **Documentation**: Part of the main-validation SDLC process
4. **Quality Assurance**: Ensures all workflow variations are tested before deployment

## Make Task Integration

The script is integrated with the repository's Make system:

### Available Tasks
```makefile
# Build the binary
make build-main-validation

# Build and run the complete test
make test-main-validation-workflow
```

### Task Dependencies
- `test-main-validation-workflow` depends on `build-main-validation`
- Binary is built in `bin/main-validation`
- Executable permissions set automatically

## Development and Maintenance

### Script Structure
- **Configuration Loading**: Strict validation with no fallbacks
- **Tool Detection**: Checks for required tools and authentication
- **Workflow Dispatch**: Uses GitHub CLI to trigger workflows
- **Error Handling**: Comprehensive error messages and validation
- **Logging**: Detailed progress and debug information

### Adding New Variations
To add new test variations:

1. Update `monorepo-config.json` with new variation in `workflow_tests.variations`
2. Ensure corresponding job exists in `main-validation.yml`
3. Update documentation to reflect new variation count
4. Test the new variation using this script

### Maintenance Considerations
- **No hardcoded values**: All configuration must come from `monorepo-config.json`
- **Validation first**: Always validate configuration before execution
- **Clear errors**: Provide helpful error messages for all failure scenarios
- **Documentation**: Keep documentation synchronized with configuration changes

## Related Documentation

- [Main Validation SDLC Guide](../main-validation-sdlc.md) - Complete workflow development process
- [Workflow Logic Documentation](../WORKFLOW_LOGIC.md) - Detailed workflow flow explanation
- [Monorepo Configuration](../monorepo-config.md) - Configuration file structure
- [Contributing Guidelines](../../CONTRIBUTING.md) - General contribution process

## Troubleshooting

### Common Issues

**Issue**: "No workflows triggered"
- **Solution**: Check GitHub CLI authentication and repository permissions

**Issue**: "Module type not found"
- **Solution**: Ensure `test_module_type` exists in `module_types` configuration

**Issue**: "Branch detection failed"
- **Solution**: Ensure you're in a git repository with a valid branch

**Issue**: "Workflow not found"
- **Solution**: Ensure `main-validation.yml` exists in the target repository

For additional help, check the error messages provided by the script - they include specific guidance for resolving issues.
