package terraform.libraries.data_file_organization.test

import data.terraform.libraries.data_file_organization as policy
import data.tests.opa.unit.helpers as helpers

# Test that variables in wrong file violate the policy
test_variables_in_wrong_file_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "variable \"test\" {\n  type = string\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) >= 1
}

# Test that outputs in wrong file violate the policy
test_outputs_in_wrong_file_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "output \"test\" {\n  value = \"test\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) >= 1
}

# Test that terraform blocks in wrong file violate the policy
test_terraform_blocks_in_wrong_file_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "terraform {\n  required_version = \">= 1.0\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) >= 1
}

# Test that required_providers in wrong file violate the policy
test_required_providers_in_wrong_file_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "required_providers {\n  aws = {\n    source = \"hashicorp/aws\"\n  }\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) >= 1
}

# Test that locals in wrong file violate the policy
test_locals_in_wrong_file_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "locals {\n  test = \"value\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) >= 1
}

# Test that properly organized files pass the policy
test_properly_organized_files_no_violation if {
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "data \"aws_caller_identity\" \"current\" {}",
		"modules/test-module/variables.tf": "variable \"test\" {\n  type = string\n}",
		"modules/test-module/outputs.tf": "output \"test\" {\n  value = \"test\"\n}",
		"modules/test-module/versions.tf": "terraform {\n  required_version = \">= 1.0\"\n}",
		"modules/test-module/locals.tf": "locals {\n  test = \"value\"\n}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) == 0
}

# Test that module with only main.tf passes (no required files)
test_minimal_module_no_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "data \"aws_caller_identity\" \"current\" {}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) == 0
}
