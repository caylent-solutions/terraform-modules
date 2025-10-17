package terraform.libraries.makefile.test

import data.terraform.libraries.makefile as policy
import data.tests.opa.unit.helpers as helpers

# Test that a Makefile not matching the skeleton violates the policy
test_makefile_not_matching_skeleton_violation if {
	# Mock input with different Makefiles
	module_path := "modules/test-module"
	files := {
		"modules/test-module/Makefile": "test: echo \"Custom test command\"",
		"skeletons/generic-skeleton/Makefile": "test: echo \"Standard test command\"",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that a matching Makefile passes the policy
test_makefile_matching_skeleton_no_violation if {
	# Mock input with matching Makefiles
	module_path := "modules/test-module"
	skeleton_content := "test: echo \"Standard test command\""
	files := {
		"modules/test-module/Makefile": skeleton_content,
		"skeletons/generic-skeleton/Makefile": skeleton_content,
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that missing Makefile violates the policy
test_missing_makefile_violation if {
	# Mock input without Makefile
	module_path := "modules/test-module"
	files := {"skeletons/generic-skeleton/Makefile": "test: echo \"Test command\""}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}
