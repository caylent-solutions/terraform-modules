# PR Title-Based Versioning

## Overview

This repository uses **PR titles** (not individual commit messages) to determine semantic version bumps during the automated release process.

## How It Works

1. **Developer creates PR** with conventional commit-formatted title
2. **PR validation runs** - validates, tests, and analyzes contributor type
3. **Tests execute** - internal: automatic, external: requires `external-contributor-test-approval` environment approval
4. **Main validation triggered** - PR validation triggers main-validation workflow
5. **Merge approval gate** - requires approval via GitHub Environment:
   - Internal (non-self-approve): `merge-approval` environment
   - Internal (self-approve): `merge-approval` environment (manual approval still required)
   - External: `external-contributor-merge-approval` environment
6. **Pipeline auto-merges** - squash merge using PR title as commit message
7. **Post-merge validation** - re-runs all tests on merged code
8. **QA certification gate** - requires approval via `qa-certification` environment
9. **Release approval gate** - requires approval via `qa-certification` environment (triggers release workflow)
10. **Release workflow runs** - analyzes commit message (PR title) to determine version bump
11. **Version tagged** - creates tag based on PR title prefix

## Why PR Titles?

When the pipeline auto-merges a PR, it performs a **squash merge** that combines all commits into a single commit. The commit message for this squash commit is the **PR title**. Since semantic versioning tools analyze commit messages on the main branch, only the PR title matters for version determination.

## PR Title Format

Use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>[optional scope]: <description>

Examples:
feat: add new S3 encryption option
fix: resolve IAM policy attachment issue
feat!: change module input variable names (breaking change)
docs: update README with new examples
```

## Version Bump Rules

| PR Title Prefix | Version Bump | Example |
|----------------|--------------|---------|
| `feat!:`, `fix!:`, etc. | **Major** (breaking) | `v1.2.3` → `v2.0.0` |
| `feat:` | **Minor** (feature) | `v1.2.3` → `v1.3.0` |
| `fix:`, `docs:`, `chore:`, etc. | **Patch** (fix) | `v1.2.3` → `v1.2.4` |

### Supported Prefixes

**Major Version Bump** (breaking changes):
- Any prefix with `!:` (e.g., `feat!:`, `fix!:`, `refactor!:`)
- Footer contains `BREAKING CHANGE`

**Minor Version Bump** (new features):
- `feat:` - New feature
- `perf:` - Performance improvement
- `build:` - Build system change
- `revert:` - Revert commit
- `release:` - Release commit
- `module:` - Module-level change
- `meta:` - Metadata change
- `ci:` - CI/CD change

**Patch Version Bump** (fixes):
- `fix:` - Bug fix
- `chore:` - Chore/maintenance
- `docs:` - Documentation change
- `style:` - Code style change
- `refactor:` - Refactoring (non-breaking)
- `test:` - Test-related change

## Important Rules

### ✅ DO

- **Format your PR title** with a conventional commit prefix
- **Choose the correct prefix** based on the type of change
- **Use `!:` for breaking changes** (e.g., `feat!:`, `fix!:`)
- **Let the pipeline merge** your PR automatically after approval

### ❌ DON'T

- **Don't manually merge PRs** through the GitHub UI
- **Don't rely on individual commit messages** for versioning
- **Don't use non-standard prefixes** in PR titles
- **Don't merge without a proper PR title**

## Examples

### Good PR Titles

```
feat: add support for KMS encryption
fix: resolve race condition in module initialization
feat!: remove deprecated input variables
docs: add examples for advanced use cases
chore: update dependencies to latest versions
refactor: simplify IAM policy logic
```

### Bad PR Titles

```
Update code                          ❌ No conventional commit prefix
Added new feature                    ❌ Not in conventional format
WIP: testing changes                 ❌ Not ready for merge
Merge pull request #123              ❌ Generic merge message
```

## Workflow Integration

### For Terraform Modules

1. PR title determines the module version bump
2. Each module is versioned independently
3. Release creates a tag like `providers/aws/primitives/s3/v1.2.3`

### For Non-Terraform Code

1. PR title determines the repository version bump
2. Repository-wide semantic versioning
3. Release creates a tag like `v1.2.3`

## Troubleshooting

### My PR was merged but no version bump occurred

- Check if your PR title had a valid conventional commit prefix
- Verify the prefix type matches the expected version bump
- Review the release workflow logs for errors

### I need to change the version bump type

- The PR title is set when you create the PR
- You can edit the PR title before it's merged
- Once merged, the version is determined and cannot be changed

### What if I made a mistake in the PR title?

- Edit the PR title before approval/merge
- If already merged, create a new PR with the correct changes
- Contact maintainers if a version needs to be corrected

## Additional Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Workflow Logic](WORKFLOW_LOGIC.md)
- [Semantic Release Implementation](.github/SEMANTIC_RELEASE_IMPLEMENTATION.md)
