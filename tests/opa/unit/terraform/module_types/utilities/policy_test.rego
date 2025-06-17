package terraform.module.utility.test

import data.terraform.module.utility as policy
import data.tests.opa.unit.helpers as helpers

# Test that resource blocks violate the policy
test_resource_blocks_violation if {
	# Mock input with resource blocks
	test_input := {"terraform_files": {"modules/utility/main.tf": "resource \"aws_s3_bucket\" \"test\" {}"}}

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect one violation
	count(violations) == 1

	# Check that the violation is what we expect
	violations[{
		"policy": "utility_module_policy",
		"severity": "error",
		"message": "Utility modules cannot contain resource blocks",
		"details": "Utility modules should only contain reusable code like locals and variables, not resources",
		"resolution": "Remove resource blocks from utility modules",
	}]
}

# Test that compliant utility module passes the policy
test_compliant_utility_module_no_violation if {
	# Mock input with only locals and variables
	test_input := {"terraform_files": {
		"modules/utility/main.tf": "locals {\n  common_tags = {\n    Environment = var.environment\n  }\n}",
		"modules/utility/variables.tf": "variable \"environment\" {\n  type = string\n}",
	}}

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that utility module with module blocks but no resources passes the policy
test_utility_module_with_modules_no_violation if {
	# Mock input with module blocks but no resources
	test_input := {"terraform_files": {"modules/utility/main.tf": "module \"labels\" {\n  source = \"cloudposse/label/null\"\n  version = \"0.25.0\"\n}"}}

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}
