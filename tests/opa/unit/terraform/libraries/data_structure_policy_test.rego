package terraform.libraries.data_structure.test

import data.terraform.libraries.data_structure as policy

# Test that missing required files violate the policy
test_missing_required_files_violation if {
	test_input := {
		"module_path": "providers/aws/data/test",
		"files": {"providers/aws/data/test/s3-data.tf": "data \"aws_s3_bucket\" \"test\" {}"},
	}
	violations := policy.violation with input as test_input
	count(violations) > 0
}

# Test that missing *-data.tf file violates the policy
test_missing_data_tf_file_violation if {
	test_input := {
		"module_path": "providers/aws/data/test",
		"files": {
			"providers/aws/data/test/README.md": "# Test",
			"providers/aws/data/test/TERRAFORM-DOCS.md": "# Docs",
			"providers/aws/data/test/CODEOWNERS": "* @team",
			"providers/aws/data/test/Makefile": "test:",
		},
	}
	violations := policy.violation with input as test_input
	count(violations) > 0
}

# Test that empty required files violate the policy
test_empty_required_files_violation if {
	test_input := {
		"module_path": "providers/aws/data/test",
		"files": {
			"providers/aws/data/test/s3-data.tf": "data \"aws_s3_bucket\" \"test\" {}",
			"providers/aws/data/test/README.md": "",
			"providers/aws/data/test/TERRAFORM-DOCS.md": "# Docs",
			"providers/aws/data/test/CODEOWNERS": "* @team",
			"providers/aws/data/test/Makefile": "test:",
			"providers/aws/data/test/examples/basic/main.tf": "module \"test\" {}",
			"providers/aws/data/test/tests/common/test.go": "package test",
		},
	}
	violations := policy.violation with input as test_input
	count(violations) > 0
}

# Test that disallowed .tf files violate the policy
test_disallowed_tf_files_violation if {
	test_input := {
		"module_path": "providers/aws/data/test",
		"files": {
			"providers/aws/data/test/s3-data.tf": "data \"aws_s3_bucket\" \"test\" {}",
			"providers/aws/data/test/resources.tf": "# Not allowed",
			"providers/aws/data/test/README.md": "# Test",
			"providers/aws/data/test/TERRAFORM-DOCS.md": "# Docs",
			"providers/aws/data/test/CODEOWNERS": "* @team",
			"providers/aws/data/test/Makefile": "test:",
			"providers/aws/data/test/examples/basic/main.tf": "module \"test\" {}",
			"providers/aws/data/test/tests/common/test.go": "package test",
		},
	}
	violations := policy.violation with input as test_input
	count(violations) > 0
}

# Test that missing examples directory violates the policy
test_missing_examples_directory_violation if {
	test_input := {
		"module_path": "providers/aws/data/test",
		"files": {
			"providers/aws/data/test/s3-data.tf": "data \"aws_s3_bucket\" \"test\" {}",
			"providers/aws/data/test/README.md": "# Test",
			"providers/aws/data/test/TERRAFORM-DOCS.md": "# Docs",
			"providers/aws/data/test/CODEOWNERS": "* @team",
			"providers/aws/data/test/Makefile": "test:",
			"providers/aws/data/test/tests/common/test.go": "package test",
		},
	}
	violations := policy.violation with input as test_input
	count(violations) > 0
}

# Test that missing tests directory violates the policy
test_missing_tests_directory_violation if {
	test_input := {
		"module_path": "providers/aws/data/test",
		"files": {
			"providers/aws/data/test/s3-data.tf": "data \"aws_s3_bucket\" \"test\" {}",
			"providers/aws/data/test/README.md": "# Test",
			"providers/aws/data/test/TERRAFORM-DOCS.md": "# Docs",
			"providers/aws/data/test/CODEOWNERS": "* @team",
			"providers/aws/data/test/Makefile": "test:",
			"providers/aws/data/test/examples/basic/main.tf": "module \"test\" {}",
		},
	}
	violations := policy.violation with input as test_input
	count(violations) > 0
}

# Test that empty *-data.tf files violate the policy
test_empty_data_tf_files_violation if {
	test_input := {
		"module_path": "providers/aws/data/test",
		"files": {
			"providers/aws/data/test/s3-data.tf": "",
			"providers/aws/data/test/README.md": "# Test",
			"providers/aws/data/test/TERRAFORM-DOCS.md": "# Docs",
			"providers/aws/data/test/CODEOWNERS": "* @team",
			"providers/aws/data/test/Makefile": "test:",
			"providers/aws/data/test/examples/basic/main.tf": "module \"test\" {}",
			"providers/aws/data/test/tests/common/test.go": "package test",
		},
	}
	violations := policy.violation with input as test_input
	count(violations) > 0
}

# Test that compliant module passes the policy
test_compliant_module_no_violation if {
	test_input := {
		"module_path": "providers/aws/data/test",
		"files": {
			"providers/aws/data/test/s3-data.tf": "data \"aws_s3_bucket\" \"test\" {}",
			"providers/aws/data/test/main.tf": "# Main file",
			"providers/aws/data/test/variables.tf": "variable \"bucket\" {}",
			"providers/aws/data/test/versions.tf": "terraform { required_version = \">= 1.0\" }",
			"providers/aws/data/test/outputs.tf": "output \"bucket_name\" { value = data.aws_s3_bucket.test.id }",
			"providers/aws/data/test/locals.tf": "locals { bucket_arn = data.aws_s3_bucket.test.arn }",
			"providers/aws/data/test/README.md": "# Test Module",
			"providers/aws/data/test/TERRAFORM-DOCS.md": "# Terraform Docs",
			"providers/aws/data/test/CODEOWNERS": "* @team",
			"providers/aws/data/test/Makefile": "test:\n\techo test",
			"providers/aws/data/test/examples/basic/main.tf": "module \"test\" {}",
			"providers/aws/data/test/tests/common/test.go": "package test",
		},
	}
	violations := policy.violation with input as test_input
	count(violations) == 0
}

# Test that multiple *-data.tf files are allowed
test_multiple_data_tf_files_allowed if {
	test_input := {
		"module_path": "providers/aws/data/test",
		"files": {
			"providers/aws/data/test/s3-data.tf": "data \"aws_s3_bucket\" \"test\" {}",
			"providers/aws/data/test/ec2-data.tf": "data \"aws_instance\" \"test\" {}",
			"providers/aws/data/test/README.md": "# Test Module",
			"providers/aws/data/test/TERRAFORM-DOCS.md": "# Terraform Docs",
			"providers/aws/data/test/CODEOWNERS": "* @team",
			"providers/aws/data/test/Makefile": "test:\n\techo test",
			"providers/aws/data/test/examples/basic/main.tf": "module \"test\" {}",
			"providers/aws/data/test/tests/common/test.go": "package test",
		},
	}
	violations := policy.violation with input as test_input
	count(violations) == 0
}
