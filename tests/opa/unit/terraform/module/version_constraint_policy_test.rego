package terraform.module.version.test

import data.terraform.module.version as policy
import data.tests.opa.unit.helpers as helpers

# Test that missing versions.tf violates the policy
test_missing_versions_tf_violation if {
	# Mock input with no versions.tf
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect violations
	count(violations) >= 1
}

# Test that incorrect version constraint violates the policy
test_incorrect_version_constraint_violation if {
	# Mock input with wrong version constraint
	module_path := "modules/test-module"
	files := {"modules/test-module/versions.tf": "terraform {\n  required_version = \">= 1.0.0\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect violations
	count(violations) >= 1
}

# Test that correct version constraint passes the policy
test_correct_version_constraint_no_violation if {
	# Mock input with correct version constraint
	module_path := "modules/test-module"
	files := {"modules/test-module/versions.tf": "terraform {\n  required_version = \">= 1.12.1\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}
