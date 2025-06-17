package empty.pr

import future.keywords.if
import future.keywords.in

# Enforces that PRs must contain at least one file change
violation[{"details": "Pull requests must modify at least one file", "message": "PR contains no file changes", "policy": "empty_pr_policy", "resolution": "Add file changes to your PR or close it if created by mistake", "severity": "error"}] if {
	# Get changed files from input
	changed_files := input.changed_files

	# Violation if no files are changed
	count(changed_files) == 0
}
