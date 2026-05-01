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

# Resource blocks inside examples/ are scaffolding for example fixtures and
# do not violate the no-resources rule on the module itself. The validator
# normalizes file paths to <module-name>/<rel-path>, so paths land with a
# leading <module-name>/ component.
test_examples_resource_blocks_allowed if {
	test_input := {"terraform_files": {
		"my-mod/main.tf": "module \"s3\" { source = \"terraform-aws-modules/s3-bucket/aws\" }",
		"my-mod/examples/basic/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
	}}
	violations := policy.violation with input as test_input
	count(violations) == 0
}

# Resource blocks inside tests/ are scaffolding for Terratest fixtures and
# do not violate the no-resources rule on the module itself.
test_tests_resource_blocks_allowed if {
	test_input := {"terraform_files": {
		"my-mod/main.tf": "module \"s3\" { source = \"terraform-aws-modules/s3-bucket/aws\" }",
		"my-mod/tests/basic/aux.tf": "resource \"aws_s3_bucket\" \"test\" {}",
	}}
	violations := policy.violation with input as test_input
	count(violations) == 0
}
