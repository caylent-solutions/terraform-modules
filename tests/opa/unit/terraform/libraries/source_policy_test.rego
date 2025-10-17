package terraform.libraries.source.test

import data.terraform.libraries.source as policy
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

# Test that external modules violate the policy (monorepo-only enforcement)
test_external_module_violation if {
	# Mock input with external module
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "module \"remote\" {\n  source = \"terraform-aws-modules/s3-bucket/aws\"\n  version = \"3.0.0\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that monorepo modules without ref violate the policy
test_monorepo_module_missing_ref_violation if {
	# Mock input with monorepo module but no ref
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "module \"caylent\" {\n  source = \"git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/s3\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that monorepo modules with ref pass
test_monorepo_module_with_ref_passes if {
	# Mock input with monorepo module and ref
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "module \"caylent\" {\n  source = \"git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/s3?ref=providers/aws/primitives/s3/v1.0.0\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that monorepo modules pass the policy
test_pinned_version_no_violation if {
	# Mock input with monorepo module
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "module \"remote\" {\n  source = \"git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/collections/vpc?ref=providers/aws/collections/vpc/v2.1.0\"\n}"}
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

# Test monorepo source with ref parameter
test_caylent_provider_source_exempt if {
	# Mock input with monorepo source
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "module \"caylent\" {\n  source = \"git::https://github.com/caylent-solutions/terraform-modules.git//providers/github/primitives/repository?ref=providers/github/primitives/repository/v1.2.3\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}
