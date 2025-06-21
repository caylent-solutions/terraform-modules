## Description
Please include a summary of the change and which issue is fixed. Please also include relevant motivation and context.

Fixes # (issue)

## Type of change
Please delete options that are not relevant.

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Test update
- [ ] Refactoring (no functional changes)

## How Has This Been Tested?
Please describe the tests that you ran to verify your changes. Provide instructions so we can reproduce.

## Checklist:
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published in downstream modules
- [ ] I have validated my module locally: `make module-validate MODULE_PATH=path/to/module MODULE_TYPE=module_type`
- [ ] I have run local tests: `cd path/to/module && make test`
- [ ] I understand that external contributors cannot modify workflow files for security reasons

## Security Notice for External Contributors
⚠️ **Important**: External contributors cannot modify files in `.github/workflows/` for security reasons. If workflow changes are needed:
1. Remove workflow modifications from your PR
2. Contact a maintainer to discuss workflow changes
3. Submit your code changes in a separate PR

## Automated Process
After submitting this PR, the following automated process will occur:
- **Security Check**: Validates contributor permissions and workflow modifications
- **Module Detection**: Determines if changes are Terraform modules or other code
- **Validation**: Runs comprehensive policy and quality checks
- **Testing**: Executes test suite (may require manual approval for external contributors)
- **Code Review**: Maintainers will review and approve changes
- **Auto-Merge**: PR will be automatically merged after approval

## Additional Notes
Add any other notes about the PR here.