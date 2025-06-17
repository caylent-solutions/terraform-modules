package terraform.module.organization.test

import data.terraform.module.organization as policy
import data.tests.opa.unit.helpers as helpers

# Test that variable declarations outside variables.tf violate the policy
test_variable_outside_variables_tf_violation if {
	# Mock input with variable declarations in wrong file
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "variable \"test\" {\n  type = string\n}",
		"modules/test-module/variables.tf": "# Variables should be here",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that output declarations outside outputs.tf violate the policy
test_output_outside_outputs_tf_violation if {
	# Mock input with output declarations in wrong file
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "output \"test\" {\n  value = \"test\"\n}",
		"modules/test-module/outputs.tf": "# Outputs should be here",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that terraform blocks outside versions.tf violate the policy
test_terraform_block_outside_versions_tf_violation if {
	# Mock input with terraform blocks in wrong file
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "terraform {\n  required_version = \">= 1.0.0\"\n}",
		"modules/test-module/versions.tf": "# Terraform blocks should be here",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that required_providers blocks outside versions.tf violate the policy
test_required_providers_outside_versions_tf_violation if {
	# Mock input with required_providers blocks in wrong file
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "terraform {\n  required_providers {\n    aws = {\n      source = \"hashicorp/aws\"\n    }\n  }\n}",
		"modules/test-module/versions.tf": "# Required providers should be here",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that locals blocks outside locals.tf violate the policy
test_locals_outside_locals_tf_violation if {
	# Mock input with locals blocks in wrong file
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "locals {\n  test = \"value\"\n}",
		"modules/test-module/locals.tf": "# Locals should be here",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that properly organized files pass the policy
test_properly_organized_files_no_violation if {
	# Mock input with properly organized files
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {\n  bucket = var.bucket_name\n}",
		"modules/test-module/variables.tf": "variable \"bucket_name\" {\n  type = string\n}",
		"modules/test-module/outputs.tf": "output \"bucket_id\" {\n  value = aws_s3_bucket.test.id\n}",
		"modules/test-module/versions.tf": "terraform {\n  required_version = \">= 1.0.0\"\n  required_providers {\n    aws = {\n      source = \"hashicorp/aws\"\n    }\n  }\n}",
		"modules/test-module/locals.tf": "locals {\n  test = \"value\"\n}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}
