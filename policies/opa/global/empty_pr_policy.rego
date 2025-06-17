package empty.pr

import future.keywords.in
import future.keywords.if

# Enforces that PRs must contain at least one file change
violation[{"policy": "empty_pr_policy", "severity": "error", "message": "PR contains no file changes", "details": "Pull requests must modify at least one file", "resolution": "Add file changes to your PR or close it if created by mistake"}] if {
    # Get changed files from input
    changed_files := input.changed_files
    
    # Violation if no files are changed
    count(changed_files) == 0
}