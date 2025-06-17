package terraform.module.tests.test

import data.terraform.module.tests as policy
import data.tests.opa.unit.helpers as helpers

# Test that missing test directory for example violates the policy
test_missing_test_directory_for_example_violation if {
	# Mock input with example but no corresponding test directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/tests/": "",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that missing common test directory for multiple examples violates the policy
test_missing_common_test_directory_violation if {
	# Mock input with multiple examples but no common test directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/examples/minimal/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/tests/complete/module_test.go": "package test",
		"modules/test-module/tests/minimal/module_test.go": "package test",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that missing required files in test directory violates the policy
test_missing_required_files_in_test_directory_violation if {
	# Mock input with test directory missing required files
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/tests/complete/": "",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that missing README.md in tests directory violates the policy
test_missing_readme_in_tests_directory_violation if {
	# Mock input with tests directory but no README.md
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/tests/complete/module_test.go": "package test",
		"modules/test-module/tests/complete/README.md": "# Complete Test",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that empty required files in test directory violate the policy
test_empty_required_files_in_test_directory_violation if {
	# Mock input with empty required files in test directory
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/tests/README.md": "",
		"modules/test-module/tests/complete/module_test.go": "",
		"modules/test-module/tests/complete/README.md": "",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that missing framework import in test files violates the policy
test_missing_framework_import_violation if {
	# Mock input with test file missing framework import
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/tests/README.md": "# Tests",
		"modules/test-module/tests/complete/module_test.go": "package test\n\nimport \"testing\"\n\nfunc TestModule(t *testing.T) {}",
		"modules/test-module/tests/complete/README.md": "# Complete Test",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that missing go.mod file violates the policy
test_missing_go_mod_violation if {
	# Mock input with no go.mod file
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/tests/README.md": "# Tests",
		"modules/test-module/tests/complete/module_test.go": "package test\n\nimport \"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx\"\n\nfunc TestModule(t *testing.T) {}",
		"modules/test-module/tests/complete/README.md": "# Complete Test",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that missing test.config file violates the policy
test_missing_test_config_violation if {
	# Mock input with no test.config file
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/tests/README.md": "# Tests",
		"modules/test-module/tests/complete/module_test.go": "package test\n\nimport \"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx\"\n\nfunc TestModule(t *testing.T) {}",
		"modules/test-module/tests/complete/README.md": "# Complete Test",
		"modules/test-module/go.mod": "module test\n\nrequire github.com/caylent-solutions/terraform-terratest-framework v1.0.0",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that missing framework dependency in go.mod violates the policy
test_missing_framework_dependency_violation if {
	# Mock input with go.mod missing framework dependency
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/tests/README.md": "# Tests",
		"modules/test-module/tests/complete/module_test.go": "package test\n\nimport \"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx\"\n\nfunc TestModule(t *testing.T) {}",
		"modules/test-module/tests/complete/README.md": "# Complete Test",
		"modules/test-module/go.mod": "module test\n\nrequire github.com/stretchr/testify v1.8.0",
		"modules/test-module/test.config": "TERRATEST_IDEMPOTENCY=true",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that missing idempotency setting in test.config violates the policy
test_missing_idempotency_setting_violation if {
	# Mock input with test.config missing idempotency setting
	module_path := "modules/test-module"
	files := {
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/tests/README.md": "# Tests",
		"modules/test-module/tests/complete/module_test.go": "package test\n\nimport \"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx\"\n\nfunc TestModule(t *testing.T) {}",
		"modules/test-module/tests/complete/README.md": "# Complete Test",
		"modules/test-module/go.mod": "module test\n\nrequire github.com/caylent-solutions/terraform-terratest-framework v1.0.0",
		"modules/test-module/test.config": "# Test configuration",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect at least one violation
	count(violations) >= 1
}

# Test that compliant test structure passes the policy
test_compliant_test_structure_no_violation if {
	# Mock input with compliant test structure
	module_path := "modules/test-module"
	files := {
		# Examples
		"modules/test-module/examples/complete/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		"modules/test-module/examples/minimal/main.tf": "resource \"aws_s3_bucket\" \"test\" {}",
		# Tests directory
		"modules/test-module/tests/": "",
		"modules/test-module/tests/README.md": "# Tests",
		# Complete test directory
		"modules/test-module/tests/complete/": "",
		"modules/test-module/tests/complete/module_test.go": "package test\n\nimport \"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx\"\n\nfunc TestModule(t *testing.T) {}",
		"modules/test-module/tests/complete/README.md": "# Complete Test",
		# Minimal test directory
		"modules/test-module/tests/minimal/": "",
		"modules/test-module/tests/minimal/module_test.go": "package test\n\nimport \"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx\"\n\nfunc TestModule(t *testing.T) {}",
		"modules/test-module/tests/minimal/README.md": "# Minimal Test",
		# Common test directory (required for multiple examples)
		"modules/test-module/tests/common/": "",
		"modules/test-module/tests/common/module_test.go": "package test\n\nimport \"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx\"\n\nfunc TestModule(t *testing.T) {}",
		"modules/test-module/tests/common/README.md": "# Common Test",
		# Module files
		"modules/test-module/go.mod": "module test\n\nrequire github.com/caylent-solutions/terraform-terratest-framework v1.0.0",
		"modules/test-module/test.config": "TERRATEST_IDEMPOTENCY=true",
	}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Verify no specific violations exist
	not contains_violation(violations, "Missing test directory for example")
	not contains_violation(violations, "Missing 'common' test directory for multiple examples")
	not contains_violation(violations, "Required file")
	not contains_violation(violations, "Missing README.md in tests directory")
	not contains_violation(violations, "cannot be empty")
	not contains_violation(violations, "Missing terraform-terratest-framework import")
	not contains_violation(violations, "Missing go.mod file")
	not contains_violation(violations, "Missing test.config file")
	not contains_violation(violations, "Missing terraform-terratest-framework dependency")
	not contains_violation(violations, "Missing TERRATEST_IDEMPOTENCY setting")
}

# Helper function to check if violations contain a specific message
contains_violation(violations, message) if {
	some violation in violations
	contains(violation.message, message)
}
