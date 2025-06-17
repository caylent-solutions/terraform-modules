package terraform.module.tests.helpers.test

import data.terraform.module.tests.helpers as policy
import data.tests.opa.unit.helpers as helpers

# Test that missing helpers.go file violates the policy
test_missing_helpers_go_violation if {
	# Mock input with helpers directory but no helpers.go
	module_path := "modules/test-module"
	files := {"modules/test-module/tests/helpers/": ""}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect violations
	count(violations) >= 1
}

# Test that missing README.md file violates the policy
test_missing_readme_violation if {
	# Mock input with helpers directory but no README.md
	module_path := "modules/test-module"
	files := {"modules/test-module/tests/helpers/helpers.go": "package helpers\n\nfunc TestHelper() {}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect violations
	count(violations) >= 1
}

# Test that empty helpers.go file violates the policy
test_empty_helpers_go_violation if {
	# Mock input with empty helpers.go
	module_path := "modules/test-module"
	files := {
		"modules/test-module/tests/helpers/helpers.go": "",
		"modules/test-module/tests/helpers/README.md": "# Test Helpers",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect violations
	count(violations) >= 1
}

# Test that compliant helpers directory passes the policy
test_compliant_helpers_no_violation if {
	# Mock input with compliant helpers directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/tests/helpers/helpers.go": "package helpers\n\nfunc TestHelper() {}",
		"modules/test-module/tests/helpers/README.md": "# Test Helpers",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that no helpers directory passes the policy
test_no_helpers_directory_no_violation if {
	# Mock input with no helpers directory
	module_path := "modules/test-module"
	files := {"modules/test-module/tests/": ""}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}
