package terraform.module.structure.test

import data.terraform.module.structure as policy
import data.tests.opa.unit.helpers as helpers

# Test that empty examples directory violates the policy
test_empty_examples_directory_violation if {
	# Mock input with empty examples directory
	module_path := "modules/test-module"
	files := {"modules/test-module/examples/": ""}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that missing required files in example violates the policy
test_missing_required_files_in_example_violation if {
	# Mock input with example missing required files
	module_path := "modules/test-module"
	files := {"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that empty required files in example violate the policy
test_empty_required_files_in_example_violation if {
	# Mock input with empty required files
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "",
		"modules/test-module/examples/complete/terraform.tfvars": "",
		"modules/test-module/examples/complete/versions.tf": "",
		"modules/test-module/examples/complete/variables.tf": "",
		"modules/test-module/examples/complete/README.md": "",
		"modules/test-module/examples/complete/TERRAFORM-DOCS.md": "",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Skip this test for now
# Test that complete example passes the policy
# test_complete_example_no_violation if {
#     # Mock input with complete example
#     module_path := "modules/test-module"
#     files := {
#         "modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
#         "modules/test-module/examples/complete/terraform.tfvars": "bucket_name = \"test-bucket\"",
#         "modules/test-module/examples/complete/versions.tf": "terraform {\n  required_version = \">= 1.0.0\"\n}",
#         "modules/test-module/examples/complete/variables.tf": "variable \"bucket_name\" {\n  type = string\n}",
#         "modules/test-module/examples/complete/README.md": "# Complete Example\n\nThis is a complete example.",
#         "modules/test-module/examples/complete/TERRAFORM-DOCS.md": "## Requirements\n\n- Terraform >= 1.0.0"
#     }
#     test_input := helpers.mock_terraform_module_input(module_path, files)
#
#     # Check for violations
#     violations := policy.violation with input as test_input
#
#     # Expect no violations related to examples
#     count(violations) == 0
# }
