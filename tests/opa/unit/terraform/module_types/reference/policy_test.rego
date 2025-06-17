package terraform.module.reference.test

import data.terraform.module.reference as policy
import data.tests.opa.unit.helpers as helpers

# Test that resource blocks violate the policy
test_resource_blocks_violation if {
	# Mock input with resource blocks
	test_input := {"terraform_files": {"modules/reference/main.tf": "resource \"aws_s3_bucket\" \"test\" {}\nmodule \"s3\" {\n  source = \"terraform-aws-modules/s3-bucket/aws\"\n  version = \"3.0.0\"\n}"}}

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect one violation
	count(violations) == 1

	# Check that the violation is what we expect
	violations[{
		"policy": "reference_module_policy",
		"severity": "error",
		"message": "Reference modules cannot contain resource blocks",
		"details": "Reference modules should only use modules, not direct resources",
		"resolution": "Replace resource blocks with appropriate module references",
	}]
}

# Test that missing module sources violate the policy
test_missing_module_sources_violation if {
	# Mock input with no module sources
	test_input := {"terraform_files": {"modules/reference/main.tf": "# No module sources here"}}

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect one violation
	count(violations) == 1

	# Check that the violation is what we expect
	violations[{
		"policy": "reference_module_policy",
		"severity": "error",
		"message": "Reference modules must use at least one source module",
		"details": "Reference modules should compose functionality from other modules",
		"resolution": "Add at least one module source to your reference module",
	}]
}

# Test that compliant reference module passes the policy
test_compliant_reference_module_no_violation if {
	# Mock input with module sources and no resource blocks
	test_input := {"terraform_files": {"modules/reference/main.tf": "module \"s3\" {\n  source = \"terraform-aws-modules/s3-bucket/aws\"\n  version = \"3.0.0\"\n}"}}

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}
