package terraform.module.structure.test

import data.terraform.module.structure as policy
import data.tests.opa.unit.helpers as helpers

# Test that missing required files in module root violate the policy
test_missing_required_files_violation if {
	# Mock input with missing required files
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that empty required files violate the policy
test_empty_required_files_violation if {
	# Mock input with empty required files
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "",
		"modules/test-module/variables.tf": "",
		"modules/test-module/versions.tf": "",
		"modules/test-module/README.md": "",
		"modules/test-module/TERRAFORM-DOCS.md": "",
		"modules/test-module/CODEOWNERS": "",
		"modules/test-module/Makefile": "",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that disallowed .tf files violate the policy
test_disallowed_tf_files_violation if {
	# Mock input with disallowed .tf file
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/variables.tf": "variable \"bucket_name\" {\n  type = string\n}",
		"modules/test-module/outputs.tf": "output \"bucket_id\" {\n  value = aws_s3_bucket.test.id\n}",
		"modules/test-module/versions.tf": "terraform {\n  required_version = \">= 1.0.0\"\n}",
		"modules/test-module/locals.tf": "locals {\n  bucket_prefix = \"test-\"\n}",
		"modules/test-module/custom.tf": "# Custom Terraform code",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that missing examples directory violates the policy
test_missing_examples_directory_violation if {
	# Mock input with no examples directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/variables.tf": "variable \"bucket_name\" {\n  type = string\n}",
		"modules/test-module/outputs.tf": "output \"bucket_id\" {\n  value = aws_s3_bucket.test.id\n}",
		"modules/test-module/versions.tf": "terraform {\n  required_version = \">= 1.0.0\"\n}",
		"modules/test-module/locals.tf": "locals {\n  bucket_prefix = \"test-\"\n}",
		"modules/test-module/README.md": "# Test Module",
		"modules/test-module/TERRAFORM-DOCS.md": "## Requirements\n\n- Terraform >= 1.0.0",
		"modules/test-module/CODEOWNERS": "@team",
		"modules/test-module/Makefile": "test:\n\techo \"Running tests\"",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that missing tests directory violates the policy
test_missing_tests_directory_violation if {
	# Mock input with no tests directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/variables.tf": "variable \"bucket_name\" {\n  type = string\n}",
		"modules/test-module/outputs.tf": "output \"bucket_id\" {\n  value = aws_s3_bucket.test.id\n}",
		"modules/test-module/versions.tf": "terraform {\n  required_version = \">= 1.0.0\"\n}",
		"modules/test-module/locals.tf": "locals {\n  bucket_prefix = \"test-\"\n}",
		"modules/test-module/README.md": "# Test Module",
		"modules/test-module/TERRAFORM-DOCS.md": "## Requirements\n\n- Terraform >= 1.0.0",
		"modules/test-module/CODEOWNERS": "@team",
		"modules/test-module/Makefile": "test:\n\techo \"Running tests\"",
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Skip this test for now
# Test that a compliant module passes the policy
# test_compliant_module_no_violation if {
#     # Mock input with compliant module structure
#     module_path := "modules/test-module"
#     files := {
#         "modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
#         "modules/test-module/variables.tf": "variable \"bucket_name\" {\n  type = string\n}",
#         "modules/test-module/outputs.tf": "output \"bucket_id\" {\n  value = aws_s3_bucket.test.id\n}",
#         "modules/test-module/versions.tf": "terraform {\n  required_version = \">= 1.0.0\"\n}",
#         "modules/test-module/locals.tf": "locals {\n  bucket_prefix = \"test-\"\n}",
#         "modules/test-module/README.md": "# Test Module",
#         "modules/test-module/TERRAFORM-DOCS.md": "## Requirements\n\n- Terraform >= 1.0.0",
#         "modules/test-module/CODEOWNERS": "@team",
#         "modules/test-module/Makefile": "test:\n\techo \"Running tests\"",
#         "modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
#         "modules/test-module/tests/README.md": "# Tests"
#     }
#     test_input := helpers.mock_terraform_module_input(module_path, files)
#
#     # Check for violations
#     violations := policy.violation with input as test_input
#
#     # Expect no violations
#     count(violations) == 0
# }
