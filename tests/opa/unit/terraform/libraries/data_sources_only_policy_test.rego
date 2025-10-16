package terraform.libraries.data_sources_only.test

import data.terraform.libraries.data_sources_only as policy

# Test that resource blocks violate the policy
test_resource_blocks_violation if {
	test_input := {"terraform_files": {"main.tf": "resource \"aws_s3_bucket\" \"test\" {}\ndata \"aws_caller_identity\" \"current\" {}"}}
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that module blocks violate the policy
test_module_blocks_violation if {
	test_input := {"terraform_files": {"main.tf": "module \"s3\" {\n  source = \"terraform-aws-modules/s3-bucket/aws\"\n}\ndata \"aws_caller_identity\" \"current\" {}"}}
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that missing data sources violate the policy
test_missing_data_sources_violation if {
	test_input := {"terraform_files": {"main.tf": "# No data sources here"}}
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that compliant data module passes the policy
test_compliant_data_module_no_violation if {
	test_input := {"terraform_files": {"main.tf": "data \"aws_caller_identity\" \"current\" {}\ndata \"aws_region\" \"current\" {}"}}
	violations := policy.violation with input as test_input
	count(violations) == 0
}
