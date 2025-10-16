package terraform.libraries.hardcoded.test

import data.terraform.libraries.hardcoded as policy
import data.tests.opa.unit.helpers as helpers

# Test that hardcoded string values violate the policy
test_hardcoded_string_violation if {
	# Mock input with hardcoded string values
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {\n  bucket = \"my-hardcoded-bucket-name\"\n}",
		"modules/test-module/variables.tf": "# Variables should be used instead",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that hardcoded numeric values violate the policy
test_hardcoded_numeric_violation if {
	# Mock input with hardcoded numeric values
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_autoscaling_group\" \"test\" {\n  max_size = 10\n  min_size = 2\n}",
		"modules/test-module/variables.tf": "# Variables should be used instead",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that hardcoded boolean values violate the policy
test_hardcoded_boolean_violation if {
	# Mock input with hardcoded boolean values
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {\n  versioning {\n    enabled = true\n  }\n}",
		"modules/test-module/variables.tf": "# Variables should be used instead",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that hardcoded JSON objects violate the policy
test_hardcoded_json_violation if {
	# Mock input with hardcoded JSON objects
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_iam_policy\" \"test\" {\n  policy = {\n    Version = \"2012-10-17\"\n    Statement = [\n      {\n        Action = \"s3:*\"\n        Effect = \"Allow\"\n        Resource = \"*\"\n      }\n    ]\n  }\n}",
		"modules/test-module/variables.tf": "# Variables should be used instead",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that using variables passes the policy
test_using_variables_no_violation if {
	# Mock input with variables instead of hardcoded values
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {\n  bucket = var.bucket_name\n  versioning {\n    enabled = var.enable_versioning\n  }\n}",
		"modules/test-module/variables.tf": "variable \"bucket_name\" {\n  type = string\n}\n\nvariable \"enable_versioning\" {\n  type = bool\n  default = false\n}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that hardcoded values in examples are allowed
test_hardcoded_values_in_examples_allowed if {
	# Mock input with hardcoded values in examples directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {\n  bucket = \"example-bucket\"\n  versioning {\n    enabled = true\n  }\n}",
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {\n  bucket = var.bucket_name\n}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that hardcoded values in tests are allowed
test_hardcoded_values_in_tests_allowed if {
	# Mock input with hardcoded values in tests directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/tests/integration/main.tf": "resource \"aws_s3_bucket\" \"test\" {\n  bucket = \"test-bucket\"\n  versioning {\n    enabled = true\n  }\n}",
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {\n  bucket = var.bucket_name\n}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

# Test that hardcoded YAML heredocs violate the policy
test_hardcoded_yaml_violation if {
	# Mock input with hardcoded YAML heredoc
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_config\" \"test\" {\n  config = <<YAML\nkey: value\nYAML\n}",
		"modules/test-module/variables.tf": "# Variables should be used instead",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test YML heredoc
test_hardcoded_yml_violation if {
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_config\" \"test\" {\n  config = <<YML\nkey: value\nYML\n}",
		"modules/test-module/variables.tf": "# Variables should be used instead",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) >= 1
}

# Test lifecycle block exemption
test_lifecycle_block_exemption if {
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_instance\" \"test\" {\n  lifecycle {\n    create_before_destroy = true\n  }\n}",
		"modules/test-module/variables.tf": "variable \"test\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) == 0
}

# Test resource block with hardcoded values
test_resource_block_hardcoded_values if {
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" { bucket = \"hardcoded\" tags = { Name = \"test\" } }",
		"modules/test-module/variables.tf": "variable \"test\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) >= 1
}

# Test JSON map hardcoded values
test_json_map_hardcoded_values if {
	module_path := "modules/test-module"
	files := {
		"modules/test-module/main.tf": "resource \"aws_iam_policy\" \"test\" { policy = { \"Version\": \"2012-10-17\" } }",
		"modules/test-module/variables.tf": "variable \"test\" {}",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) >= 1
}
