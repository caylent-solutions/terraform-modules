package terraform.module.makefile.test

import data.terraform.module.makefile as policy
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

# Test that nested modules violate the policy
test_nested_modules_violation if {
	# Mock input with nested module structure
	module_path := "modules/test-module"
	files := {
		"modules/test-module/Makefile": "test: echo \"Test command\"",
		"skeletons/generic-skeleton/Makefile": "test: echo \"Different command\"",
		"modules/test-module/nested/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that examples and tests directories are allowed
test_examples_and_tests_allowed if {
	# Mock input with examples and tests directories
	module_path := "modules/test-module"
	files := {
		"modules/test-module/Makefile": "test: echo \"Test command\"",
		"skeletons/generic-skeleton/Makefile": "test: echo \"Test command\"",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}
