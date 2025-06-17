package terraform.module.naming.test

import data.terraform.module.naming as policy
import data.tests.opa.unit.helpers as helpers

# Test that dynamic resource names with interpolation violate the policy
test_dynamic_resource_name_interpolation_violation if {
	# Mock input with dynamic resource name using interpolation
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"${var.environment}_bucket\" {\n  bucket = var.bucket_name\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that dynamic resource names with functions violate the policy
test_dynamic_resource_name_function_violation if {
	# Mock input with dynamic resource name using functions
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"concat(var.environment, \"_bucket\")\" {\n  bucket = var.bucket_name\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that static resource names pass the policy
test_static_resource_name_no_violation if {
	# Mock input with static resource name
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"bucket\" {\n  bucket = var.bucket_name\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that dynamic names in examples are allowed
test_dynamic_names_in_examples_allowed if {
	# Mock input with dynamic resource name in examples directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"${var.environment}_bucket\" {\n  bucket = var.bucket_name\n}",
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"bucket\" {\n  bucket = var.bucket_name\n}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}
