package empty.pr.test

import data.empty.pr as policy
import data.tests.opa.unit.helpers as helpers

# Test that a PR with no file changes violates the policy
test_empty_pr_violation if {
	# Mock input with no changed files
	test_input := helpers.mock_pr_input([])

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect one violation
	count(violations) == 1

	# Check that the violation is what we expect
	violations[{"policy": "empty_pr_policy", "severity": "error", "message": "PR contains no file changes", "details": "Pull requests must modify at least one file", "resolution": "Add file changes to your PR or close it if created by mistake"}]
}

# Test that a PR with file changes passes the policy
test_non_empty_pr_no_violation if {
	# Mock input with some changed files
	test_input := helpers.mock_pr_input(["file1.txt", "file2.tf"])

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}
