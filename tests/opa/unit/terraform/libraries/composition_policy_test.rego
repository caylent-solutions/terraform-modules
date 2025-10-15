package terraform.libraries.composition.test

import data.terraform.libraries.composition as policy

# Test that resource blocks violate the policy
test_resource_blocks_violation if {
	test_input := {"terraform_files": {"main.tf": "resource \"aws_s3_bucket\" \"test\" {}\nmodule \"s3\" {\n  source = \"terraform-aws-modules/s3-bucket/aws\"\n  version = \"3.0.0\"\n}"}}
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that missing module sources violate the policy
test_missing_module_sources_violation if {
	test_input := {"terraform_files": {"main.tf": "# No module sources here"}}
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that compliant module passes the policy
test_compliant_module_no_violation if {
	test_input := {"terraform_files": {"main.tf": "module \"s3\" {\n  source = \"terraform-aws-modules/s3-bucket/aws\"\n  version = \"3.0.0\"\n}"}}
	violations := policy.violation with input as test_input
	count(violations) == 0
}
