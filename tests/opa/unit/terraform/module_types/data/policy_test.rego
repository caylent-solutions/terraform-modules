package terraform.module.data.test

import data.terraform.module.data as policy
import data.tests.opa.unit.helpers as helpers

# Test that resource blocks violate the policy
test_resource_blocks_violation if {
	# Mock input with resource blocks
	test_input := {"terraform_files": {"modules/data/main.tf": "resource \"aws_s3_bucket\" \"test\" {}\ndata \"aws_caller_identity\" \"current\" {}"}}

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect one violation
	count(violations) == 1

	# Check that the violation is what we expect
	violations[{
		"policy": "data_module_policy",
		"severity": "error",
		"message": "Data modules cannot contain resource blocks",
		"details": "Data modules should only contain data sources for querying existing resources",
		"resolution": "Replace resource blocks with data source blocks or move to appropriate module type",
	}]
}

# Test that module blocks violate the policy
test_module_blocks_violation if {
	# Mock input with module blocks
	test_input := {"terraform_files": {"modules/data/main.tf": "module \"s3\" {\n  source = \"terraform-aws-modules/s3-bucket/aws\"\n  version = \"3.0.0\"\n}\ndata \"aws_caller_identity\" \"current\" {}"}}

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect one violation
	count(violations) == 1

	# Check that the violation is what we expect
	violations[{
		"policy": "data_module_policy",
		"severity": "error",
		"message": "Data modules cannot contain module blocks",
		"details": "Data modules should only contain data sources for querying existing resources",
		"resolution": "Remove module blocks or move to collection module type",
	}]
}

# Test that missing data sources violate the policy
test_missing_data_sources_violation if {
	# Mock input with no data sources
	test_input := {"terraform_files": {"modules/data/main.tf": "# No data sources here"}}

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect one violation
	count(violations) == 1

	# Check that the violation is what we expect
	violations[{
		"policy": "data_module_policy",
		"severity": "error",
		"message": "Data modules must contain at least one data source",
		"details": "Data modules should contain data sources for querying existing resources",
		"resolution": "Add at least one data source to your data module",
	}]
}

# Test that compliant data module passes the policy
test_compliant_data_module_no_violation if {
	# Mock input with data sources only
	test_input := {"terraform_files": {"modules/data/main.tf": "data \"aws_caller_identity\" \"current\" {}\ndata \"aws_region\" \"current\" {}"}}

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}