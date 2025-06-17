package terraform.module.structure

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Check for required files in the root of the module
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Required files in the root directory
	required_files := {
		"main.tf",
		"variables.tf",
		"versions.tf",
		"README.md",
		"TERRAFORM-DOCS.md",
		"CODEOWNERS",
		"Makefile",
	}

	# Check if any required file is missing
	some file in required_files
	not file_exists(module_path, file)

	result := {
		"policy": "terraform_module_structure_policy",
		"severity": "error",
		"message": sprintf("Required file '%s' is missing in module root", [file]),
		"details": sprintf("Module '%s' must contain '%s' in its root directory", [module_path, file]),
		"resolution": sprintf("Create the missing '%s' file in the module root", [file]),
	}
}

# Check for non-empty required files
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Files that cannot be empty
	non_empty_files := {
		"main.tf",
		"variables.tf",
		"versions.tf",
		"README.md",
		"TERRAFORM-DOCS.md",
		"CODEOWNERS",
		"Makefile",
	}

	# Check if any required file is empty
	some file in non_empty_files
	file_exists(module_path, file)
	file_is_empty(module_path, file)

	result := {
		"policy": "terraform_module_structure_policy",
		"severity": "error",
		"message": sprintf("Required file '%s' cannot be empty", [file]),
		"details": sprintf("Module '%s' contains an empty '%s' file", [module_path, file]),
		"resolution": sprintf("Add content to the '%s' file", [file]),
	}
}

# Check for only allowed .tf files in the root
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Allowed .tf files in the root directory
	allowed_tf_files := {
		"main.tf",
		"variables.tf",
		"outputs.tf",
		"versions.tf",
		"locals.tf",
	}

	# Get all .tf files in the root
	tf_files := list_files(module_path)

	# Check for disallowed .tf files
	some file in tf_files
	endswith(file, ".tf")
	not file in allowed_tf_files

	result := {
		"policy": "terraform_module_structure_policy",
		"severity": "error",
		"message": sprintf("Disallowed .tf file '%s' in module root", [file]),
		"details": sprintf("Module '%s' contains '%s' which is not allowed in the root directory", [module_path, file]),
		"resolution": sprintf("Remove or rename '%s', only %s are allowed", [file, concat(", ", allowed_tf_files)]),
	}
}

# Check for examples directory and required files
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Check if examples directory exists
	not dir_exists(module_path, "examples")

	result := {
		"policy": "terraform_module_structure_policy",
		"severity": "error",
		"message": "Missing 'examples' directory",
		"details": sprintf("Module '%s' must contain an 'examples' directory", [module_path]),
		"resolution": "Create an 'examples' directory with at least one example implementation",
	}
}

# Check for tests directory and required structure
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Check if tests directory exists
	not dir_exists(module_path, "tests")

	result := {
		"policy": "terraform_module_structure_policy",
		"severity": "error",
		"message": "Missing 'tests' directory",
		"details": sprintf("Module '%s' must contain a 'tests' directory", [module_path]),
		"resolution": "Create a 'tests' directory with the required structure",
	}
}

# Helper functions
file_exists(module_path, file) if {
	input.files[sprintf("%s/%s", [module_path, file])]
}

file_is_empty(module_path, file) if {
	content := input.files[sprintf("%s/%s", [module_path, file])]
	count(trim_space(content)) == 0
}

dir_exists(module_path, dir) if {
	some file in object.keys(input.files)
	startswith(file, sprintf("%s/%s/", [module_path, dir]))
}

list_files(dir) := files if {
	files := {file |
		some path in object.keys(input.files)
		startswith(path, sprintf("%s/", [dir]))
		not contains(substring(path, count(dir) + 1, -1), "/")
		file := substring(path, count(dir) + 1, -1)
	}
}
