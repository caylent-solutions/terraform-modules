# 🧬 SDLC Guide for `main-validation.yml`

This document defines the Software Development Lifecycle (SDLC), branching strategy, validation processes, and deployment procedures for making changes to the `main-validation.yml` workflow in this repository.

---

## 📁 1. Directory & Ownership

- **Location**: `.github/workflows/main-validation.yml`
- **Purpose**: Core validation workflow that handles PR approval routing, merge decisions, and release orchestration
- **Ownership**: Platform Engineering / Solutions Automation Team
- **Criticality**: **HIGH** - This workflow controls all PR merges and release processes

---

## 🌱 2. Development Branching Strategy

### ✅ Required Approach
- All changes **must originate from a feature branch**
- **No direct pushes to `main`** are allowed for workflow files
- Use descriptive branch names following the pattern:
  - `feature/validation-<short-desc>` (for new features)
  - `fix/validation-<short-desc>` (for bug fixes)
  - `refactor/validation-<short-desc>` (for refactoring)

### 🔄 Example Branch Names
```bash
feature/validation-add-dry-run-mode
fix/validation-slack-notification-format
refactor/validation-merge-routing-logic
```

### ⚠️ Avoid Direct Edits to `main`
- Changes to `main-validation.yml` must go through **PR review** and **comprehensive testing**
- Emergency hotfixes still require PR process (can be expedited with maintainer approval)

---

## 🧪 3. Validation & Testing Process

### ✅ PR Requirements
A PR touching `main-validation.yml` must satisfy:

1. **Code Review Requirements**:
   - At least 2 approvals from platform engineering team
   - CODEOWNERS approval required
   - All GitHub checks must pass

2. **Testing Requirements**:
   - Dry run testing completed and documented
   - Real-world scenario testing (when safe)
   - Regression testing for existing functionality

3. **Documentation Requirements**:
   - Inline comments for complex logic
   - Update to this SDLC document if process changes
   - Changelog entry for significant changes

### 🧪 Dry Run Testing (REQUIRED)

**All changes must be tested in dry run mode before real deployment.**

#### Dry Run Capabilities
- ✅ Full simulation of PR merge logic
- ✅ Complete routing decision testing
- ✅ Slack notification testing (with dry run indicators)
- ✅ Release orchestration testing (no actual release)
- ✅ All validation steps execute normally
- 🚫 No actual PR merges occur
- 🚫 No release workflows triggered

#### Dry Run Trigger Template
```yaml
workflow_dispatch:
  inputs:
    change_type: "terraform"                    # or "non-terraform"
    contributor_type: "Internal"                # or "External"
    contributor_username: "test-user"
    can_self_approve: "false"                   # or "true"
    code_owners: "user1,user2"
    module_path: "providers/aws/primitives/s3"  # if terraform
    module_type: "primitive"                    # if terraform
    pr_number: "9999"
    pr_title: "Test PR for validation logic"
    pr_html_url: "https://github.com/org/repo/pull/9999"
    dryrun: true                               # KEY: Enable dry run mode
```

#### Dry Run Test Scenarios
Test **all** of these scenarios in dry run mode:

1. **Non-Terraform Changes**:
   - Internal contributor (self-approve enabled)
   - Internal contributor (self-approve disabled)
   - External contributor

2. **Terraform Changes**:
   - Internal contributor (self-approve enabled)
   - Internal contributor (self-approve disabled)
   - External contributor

3. **Error Scenarios**:
   - Invalid inputs
   - Missing required parameters
   - Mixed change types

### 🔍 Pre-Merge Validation Checklist

- [ ] All dry run scenarios tested successfully
- [ ] Slack notifications include dry run indicators
- [ ] No actual merges/releases occur during dry run
- [ ] All routing logic functions correctly
- [ ] Error handling works as expected
- [ ] Logging is comprehensive and clear
- [ ] Performance impact assessed (if applicable)

---

## 🔁 4. Review and Merge Process

### Required Checks
- **✅ PR Validation Complete**: All standard PR checks pass
- **✅ Workflow Syntax**: GitHub Actions workflow syntax is valid
- **✅ Dry Run Testing**: All scenarios tested and documented
- **✅ Code Review**: Platform engineering team approval
- **✅ Documentation**: Inline comments and docs updated

### Merge Strategy
- **Squash merge into main** (required)
- **Never use CLI merge** - always use GitHub UI to ensure hooks and protections run
- **Merge commit message** must be descriptive and include issue/ticket references

### Post-Merge Actions
- Monitor first few real workflow executions
- Verify Slack notifications work correctly
- Check performance impact on build times
- Update any dependent documentation

---

## 🚀 5. Release Deployment Logic

### Automatic Triggers
Merges to `main` that modify `main-validation.yml` will:

1. **Immediately activate** the new workflow version
2. **Trigger post-merge validation** if other changes are included
3. **Send Slack notifications** about workflow updates
4. **Log deployment** in workflow execution history

### Release Workflow Integration
- `main-validation.yml` changes affect release processes
- Changes to release logic require **QA certification**
- `release-approval` job controls downstream release workflows

### Rollback Strategy
- **Emergency rollback**: Revert commit and immediate hotfix PR
- **Planned rollback**: Feature flag approach using conditional logic
- **Partial rollback**: Disable specific features using workflow inputs

---

## 📜 6. Versioning & History

### Version Tracking
- **No semantic versioning** for workflow files
- **Git history** serves as version control
- **Tag major changes** with descriptive Git tags: `workflow-v1.2.0`

### Commit Message Standards
Use [Conventional Commits](https://www.conventionalcommits.org/) format:

```bash
feat(validation): add dry run mode for safe testing
fix(validation): resolve slack notification formatting
refactor(validation): improve merge routing logic
docs(validation): update SDLC process documentation
```

### Change Categories
- **feat**: New features or capabilities
- **fix**: Bug fixes and corrections
- **refactor**: Code improvements without functional changes
- **docs**: Documentation updates
- **perf**: Performance improvements
- **security**: Security-related changes

---

## 🛑 7. Failsafe Rules & Safety Measures

### Critical Safety Checks
Any step that performs **destructive actions** must verify dry run status:

```yaml
# ✅ REQUIRED pattern for merge actions
if: success() && needs.merge-approval-routing.outputs.dryrun != 'true'

# ✅ REQUIRED pattern for release actions  
if: success() && needs.merge-approval-routing.outputs.dryrun != 'true'
```

### Protected Actions
These actions are **NEVER** allowed when `dryrun == true`:

- `gh pr merge` commands
- `github.rest.pulls.merge` API calls
- `github.rest.actions.createWorkflowDispatch` for releases
- Any `git tag` or release creation

### Validation Requirements
- **Double-check** all conditional logic during code review
- **Test** both dry run and real execution paths
- **Verify** that safety conditions are properly implemented
- **Monitor** execution logs for unexpected behavior

---

## 📓 8. Documentation Expectations

### Required Documentation Updates
Any change to `main-validation.yml` must include:

1. **Inline Comments**: Explain complex logic and decision points
2. **SDLC Updates**: Update this document if process changes
3. **Workflow Logic**: Update `docs/WORKFLOW_LOGIC.md` if flow changes
4. **README Updates**: Update main README if new features affect users

### Documentation Standards
- Use clear, concise language
- Include examples for complex concepts
- Provide troubleshooting guidance
- Link to related documentation

### Observability Requirements
- **Comprehensive logging** for all decision points
- **Slack notifications** for key events
- **Structured output** using `::group::` and `::notice::`
- **Error context** in failure scenarios

---

## 👥 9. Contributor Guidance

### Internal Contributors
- **Can self-approve** minor changes (with team notification)
- **Must document** intent and test coverage
- **Should coordinate** with team for major changes
- **Must test** in dry run mode before proposing changes

### External Contributors
- **Cannot modify** workflow files directly
- **Must propose changes** through issues first
- **Require manual approval** for all workflow-related PRs
- **Limited to** non-critical workflow improvements

### Platform Engineering Team
- **Responsible for** workflow maintenance and evolution
- **Must review** all workflow changes
- **Should mentor** other contributors
- **Maintains** this SDLC documentation

---

## 🔍 10. Troubleshooting Common Issues

### Issue Resolution Guide

| Issue | Symptoms | Resolution |
|-------|----------|------------|
| **Dry run bypass** | `dryrun == true` but merge/release still happens | Verify all merge/release steps use `needs.merge-approval-routing.outputs.dryrun != 'true'` condition |
| **Input unavailable** | `inputs.dryrun` unavailable in downstream jobs | Use `needs.merge-approval-routing.outputs.dryrun` instead of direct input access |
| **Missing dry run indicator** | Slack notifications don't show dry run status | Add `*Dry Run Mode:* ${{ needs.merge-approval-routing.outputs.dryrun }}` to Slack payload |
| **Routing failures** | Jobs don't execute as expected | Check `needs` dependencies include `merge-approval-routing` |
| **Real PR test failures** | Tests fail with real PR data | Use actual open PR number and ensure all permissions are correct |
| **Conditional logic errors** | Wrong jobs execute | Verify string comparison uses `'true'` not boolean `true` |

### Debug Techniques

1. **Enable Debug Logging**:
   ```yaml
   - name: Debug routing outputs
     run: |
       echo "::debug::dryrun=${{ needs.merge-approval-routing.outputs.dryrun }}"
       echo "::debug::change_type=${{ needs.merge-approval-routing.outputs.change_type }}"
   ```

2. **Use Dry Run for Debugging**:
   - Always test changes in dry run mode first
   - Compare dry run vs real execution logs
   - Verify conditional logic works correctly

3. **Check Workflow Syntax**:
   ```bash
   # Use GitHub CLI to validate workflow syntax
   gh workflow view main-validation.yml
   ```

### Emergency Procedures

#### Workflow Blocking All PRs
1. **Immediate**: Disable workflow temporarily
2. **Investigate**: Check recent changes and error logs
3. **Hotfix**: Create emergency PR with fix
4. **Test**: Verify fix in dry run mode
5. **Deploy**: Merge hotfix and re-enable workflow

#### Incorrect Merges/Releases
1. **Stop**: Pause any running workflows
2. **Assess**: Determine impact and affected PRs
3. **Rollback**: Revert problematic changes
4. **Communicate**: Notify team and affected contributors
5. **Fix**: Implement proper fix and test thoroughly

---

## 📊 11. Monitoring & Metrics

### Key Metrics to Track
- **Workflow execution time** (target: < 15 minutes)
- **Success rate** (target: > 95%)
- **Dry run usage** (should be > 80% for changes)
- **Manual intervention rate** (target: < 5%)

### Alerting Thresholds
- **Failure rate > 10%**: Alert platform team
- **Execution time > 20 minutes**: Performance investigation
- **Dry run bypass detected**: Security alert

### Health Checks
- **Weekly**: Review workflow performance metrics
- **Monthly**: Audit dry run usage and safety compliance
- **Quarterly**: Review and update SDLC process

---

## 🎯 12. Best Practices Summary

### ✅ DO
- Always test in dry run mode first
- Use descriptive commit messages
- Document complex logic with inline comments
- Coordinate with team for major changes
- Monitor first few executions after changes
- Use proper conditional logic for safety checks

### ❌ DON'T
- Push directly to main branch
- Skip dry run testing
- Ignore safety conditions
- Make undocumented changes
- Bypass code review process
- Test with production data without dry run

### 🎪 Golden Rules
1. **Safety First**: Always use dry run mode for testing
2. **Document Everything**: Code, process, and decisions
3. **Test Thoroughly**: All scenarios, edge cases, and error conditions
4. **Collaborate**: Work with team, don't work in isolation
5. **Monitor**: Watch execution and performance post-deployment

---

*This document is maintained by the Platform Engineering team and should be updated whenever the SDLC process changes.*
