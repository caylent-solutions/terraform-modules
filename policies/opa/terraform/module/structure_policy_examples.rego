package terraform.module.structure

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Check for example subdirectories in examples directory
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Check if examples directory exists but has no subdirectories
	examples_dir_exists(module_path)
	example_dirs := {dir |
		some file in object.keys(input.files)
		startswith(file, sprintf("%s/examples/", [module_path]))
		parts := split(substring(file, count(sprintf("%s/examples/", [module_path])), -1), "/")
		count(parts) > 0
		dir := parts[0]
	}
	count(example_dirs) == 0

	result := {
		"policy": "terraform_module_structure_policy",
		"severity": "error",
		"message": "No example implementations found",
		"details": sprintf("Module '%s' has an 'examples' directory but no example implementations", [module_path]),
		"resolution": "Create at least one example implementation in the examples directory",
	}
}

# Check for required files in each example directory
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Required files in each example directory
	required_example_files := {
		"main.tf",
		"terraform.tfvars",
		"versions.tf",
		"variables.tf",
		"README.md",
		"TERRAFORM-DOCS.md",
	}

	# Get all example directories
	example_dirs := {dir |
		some file in object.keys(input.files)
		startswith(file, sprintf("%s/examples/", [module_path]))
		parts := split(substring(file, count(sprintf("%s/examples/", [module_path])), -1), "/")
		count(parts) > 0
		dir := parts[0]
	}

	# Check if any required file is missing in any example directory
	some dir in example_dirs
	some file in required_example_files
	not example_file_exists(module_path, dir, file)

	result := {
		"policy": "terraform_module_structure_policy",
		"severity": "error",
		"message": sprintf("Required file '%s' is missing in example '%s'", [file, dir]),
		"details": sprintf("Example '%s' in module '%s' must contain '%s'", [dir, module_path, file]),
		"resolution": sprintf("Create the missing '%s' file in the '%s' example directory", [file, dir]),
	}
}

# Check for non-empty required files in examples
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Files that cannot be empty in examples
	non_empty_example_files := {
		"main.tf",
		"terraform.tfvars",
		"versions.tf",
		"variables.tf",
		"README.md",
		"TERRAFORM-DOCS.md",
	}

	# Get all example directories
	example_dirs := {dir |
		some file in object.keys(input.files)
		startswith(file, sprintf("%s/examples/", [module_path]))
		parts := split(substring(file, count(sprintf("%s/examples/", [module_path])), -1), "/")
		count(parts) > 0
		dir := parts[0]
	}

	# Check if any required file is empty in any example directory
	some dir in example_dirs
	some file in non_empty_example_files
	example_file_exists(module_path, dir, file)
	example_file_is_empty(module_path, dir, file)

	result := {
		"policy": "terraform_module_structure_policy",
		"severity": "error",
		"message": sprintf("Required file '%s' in example '%s' cannot be empty", [file, dir]),
		"details": sprintf("Example '%s' in module '%s' contains an empty '%s' file", [dir, module_path, file]),
		"resolution": sprintf("Add content to the '%s' file in the '%s' example directory", [file, dir]),
	}
}

# Helper functions for examples
examples_dir_exists(module_path) if {
	some file in object.keys(input.files)
	startswith(file, sprintf("%s/examples/", [module_path]))
}

example_file_exists(module_path, example_dir, file) if {
	input.files[sprintf("%s/examples/%s/%s", [module_path, example_dir, file])]
}

example_file_is_empty(module_path, example_dir, file) if {
	content := input.files[sprintf("%s/examples/%s/%s", [module_path, example_dir, file])]
	count(trim_space(content)) == 0
}
