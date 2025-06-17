package terraform.module.source.test

import data.terraform.module.source as policy
import data.tests.opa.unit.helpers as helpers

# Test that local module sources violate the policy
test_local_module_source_violation if {
	# Mock input with local module source
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "module \"local\" {\n  source = \"../other-module\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that absolute path module sources violate the policy
test_absolute_path_module_source_violation if {
	# Mock input with absolute path module source
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "module \"local\" {\n  source = \"/path/to/module\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that module sources without version constraints violate the policy
test_missing_version_constraint_violation if {
	# Mock input with module source but no version
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "module \"remote\" {\n  source = \"terraform-aws-modules/s3-bucket/aws\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that external modules with non-pinned versions violate the policy
test_non_pinned_version_violation if {
	# Mock input with external module and non-pinned version
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "module \"remote\" {\n  source = \"terraform-aws-modules/s3-bucket/aws\"\n  version = \">= 3.0.0\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that caylent modules are exempt from pinned version requirement
test_caylent_module_exempt_from_pinned_version if {
	# Mock input with caylent module and non-pinned version
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "module \"caylent\" {\n  source = \"github.com/caylent-solutions/terraform-modules/aws/s3\"\n  version = \">= 1.0.0\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that remote modules with pinned versions pass the policy
test_pinned_version_no_violation if {
	# Mock input with external module and pinned version
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "module \"remote\" {\n  source = \"terraform-aws-modules/s3-bucket/aws\"\n  version = \"3.0.0\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that local sources in examples are allowed
test_local_sources_in_examples_allowed if {
	# Mock input with local module source in examples directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "module \"local\" {\n  source = \"../../\"\n}",
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"bucket\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}
