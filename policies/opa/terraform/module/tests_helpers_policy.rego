package terraform.module.tests.helpers

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Check for helpers directory requirements
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Check if helpers directory exists
	helpers_dir_exists := dir_exists(module_path, "tests/helpers")

	# If helpers directory exists, check for required files
	helpers_dir_exists

	# Check if helpers.go exists
	helpers_go_file := sprintf("%s/tests/helpers/helpers.go", [module_path])
	not input.files[helpers_go_file]

	result := {
		"policy": "terraform_module_tests_helpers_policy",
		"severity": "error",
		"message": "Missing helpers.go file in tests/helpers directory",
		"details": sprintf("Module '%s' has a tests/helpers directory but is missing the required helpers.go file", [module_path]),
		"resolution": "Create a helpers.go file in the tests/helpers directory",
	}
}

# Check for README.md in helpers directory
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Check if helpers directory exists
	helpers_dir_exists := dir_exists(module_path, "tests/helpers")

	# If helpers directory exists, check for README.md
	helpers_dir_exists

	# Check if README.md exists
	readme_file := sprintf("%s/tests/helpers/README.md", [module_path])
	not input.files[readme_file]

	result := {
		"policy": "terraform_module_tests_helpers_policy",
		"severity": "error",
		"message": "Missing README.md file in tests/helpers directory",
		"details": sprintf("Module '%s' has a tests/helpers directory but is missing the required README.md file", [module_path]),
		"resolution": "Create a README.md file in the tests/helpers directory",
	}
}

# Check for empty helpers.go file
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Check if helpers directory exists
	helpers_dir_exists := dir_exists(module_path, "tests/helpers")

	# If helpers directory exists, check if helpers.go is empty
	helpers_dir_exists

	# Check if helpers.go exists and is empty
	helpers_go_file := sprintf("%s/tests/helpers/helpers.go", [module_path])
	input.files[helpers_go_file]
	content := input.files[helpers_go_file]
	count(trim_space(content)) == 0

	result := {
		"policy": "terraform_module_tests_helpers_policy",
		"severity": "error",
		"message": "Empty helpers.go file in tests/helpers directory",
		"details": sprintf("Module '%s' has an empty helpers.go file in the tests/helpers directory", [module_path]),
		"resolution": "Add content to the helpers.go file",
	}
}

# Helper function to check if directory exists
dir_exists(module_path, dir) if {
	some file in object.keys(input.files)
	startswith(file, sprintf("%s/%s/", [module_path, dir]))
}
