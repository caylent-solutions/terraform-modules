package terraform.libraries.nested_modules.test

import data.terraform.libraries.nested_modules as policy
import data.tests.opa.unit.helpers as helpers

# Test that nested .tf files in subdirectories trigger violations
test_nested_tf_files_violation if {
	# Mock input with nested .tf file in subdirectory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/subdir/nested.tf": "resource \"aws_s3_bucket\" \"nested\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect exactly one violation
	count(violations) == 1
}

# Test that multiple nested .tf files trigger violations
test_multiple_nested_tf_files_violation if {
	# Mock input with multiple nested .tf files
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/subdir1/nested1.tf": "resource \"aws_s3_bucket\" \"nested1\" {}",
		"modules/test-module/subdir2/nested2.tf": "resource \"aws_s3_bucket\" \"nested2\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect exactly one violation
	count(violations) == 1
}

# Test that files in examples/ directory are allowed
test_examples_directory_allowed if {
	# Mock input with .tf files in examples directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"example\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that files in tests/ directory are allowed
test_tests_directory_allowed if {
	# Mock input with .tf files in tests directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/tests/fixtures/main.tf": "resource \"aws_s3_bucket\" \"fixture\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that files in module root pass the policy
test_root_files_no_violation if {
	# Mock input with only root-level .tf files
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/variables.tf": "variable \"bucket_name\" { type = string }",
		"modules/test-module/outputs.tf": "output \"bucket_id\" { value = aws_s3_bucket.test.id }",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that deeply nested .tf files trigger violations
test_deeply_nested_tf_files_violation if {
	# Mock input with deeply nested .tf file
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/subdir/nested/deep/file.tf": "resource \"aws_s3_bucket\" \"deep\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect exactly one violation
	count(violations) == 1
}

# Test that non-.tf files in subdirectories are allowed
test_non_tf_files_in_subdirs_allowed if {
	# Mock input with non-.tf files in subdirectories
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/subdir/README.md": "# Documentation",
		"modules/test-module/subdir/config.json": "{}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that nested files in both examples and tests are allowed together
test_examples_and_tests_both_allowed if {
	# Mock input with .tf files in both examples and tests
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"example\" {}",
		"modules/test-module/tests/fixtures/main.tf": "resource \"aws_s3_bucket\" \"fixture\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}
