package terraform.libraries.data_sources_only.test

import data.terraform.libraries.data_sources_only as policy

# Test that resource blocks violate the policy
test_resource_blocks_violation if {
	test_input := {"files": {"providers/aws/data/test/main.tf": "resource \"aws_s3_bucket\" \"test\" {}", "providers/aws/data/test/aws-data.tf": "locals { test = 1 }", "providers/aws/data/test/outputs.tf": "output \"test\" { value = 1 }"}}
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that module blocks outside examples violate the policy
test_module_blocks_violation if {
	test_input := {"files": {"providers/aws/data/test/main.tf": "module \"s3\" { source = \"terraform-aws-modules/s3-bucket/aws\" }", "providers/aws/data/test/aws-data.tf": "locals { test = 1 }", "providers/aws/data/test/outputs.tf": "output \"test\" { value = 1 }"}}
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that missing locals in data files violates the policy
test_missing_locals_in_data_files_violation if {
	test_input := {"files": {"providers/aws/data/test/aws-data.tf": "# No locals here", "providers/aws/data/test/outputs.tf": "output \"test\" { value = 1 }"}}
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that missing outputs violates the policy
test_missing_outputs_violation if {
	test_input := {"files": {"providers/aws/data/test/aws-data.tf": "locals { test = 1 }", "providers/aws/data/test/outputs.tf": "# No outputs here"}}
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that module blocks in examples are allowed
test_module_blocks_in_examples_allowed if {
	test_input := {"files": {"providers/aws/data/test/examples/basic/main.tf": "module \"test\" { source = \"../../\" }", "providers/aws/data/test/aws-data.tf": "locals { test = 1 }", "providers/aws/data/test/outputs.tf": "output \"test\" { value = 1 }"}}
	violations := policy.violation with input as test_input
	count(violations) == 0
}

# Test that compliant data module passes the policy
test_compliant_data_module_no_violation if {
	test_input := {"files": {"providers/aws/data/test/aws-data.tf": "locals { test = 1 }", "providers/aws/data/test/outputs.tf": "output \"test\" { value = 1 }"}}
	violations := policy.violation with input as test_input
	count(violations) == 0
}
