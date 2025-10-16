package terraform.libraries.no_resources.test

import data.terraform.libraries.no_resources as policy

# Test that resource blocks violate the policy
test_resource_blocks_violation if {
	test_input := {"terraform_files": {"main.tf": "resource \"aws_s3_bucket\" \"test\" {}"}}
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that modules without resources pass the policy
test_no_resources_no_violation if {
	test_input := {"terraform_files": {"main.tf": "locals {\n  name = \"test\"\n}"}}
	violations := policy.violation with input as test_input
	count(violations) == 0
}

# Test that data sources are allowed
test_data_sources_allowed if {
	test_input := {"terraform_files": {"main.tf": "data \"aws_caller_identity\" \"current\" {}"}}
	violations := policy.violation with input as test_input
	count(violations) == 0
}

# Test that modules are allowed
test_modules_allowed if {
	test_input := {"terraform_files": {"main.tf": "module \"s3\" {\n  source = \"terraform-aws-modules/s3-bucket/aws\"\n}"}}
	violations := policy.violation with input as test_input
	count(violations) == 0
}
