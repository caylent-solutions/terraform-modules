package terraform.libraries.data_structure

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Check for required files in the root of the module
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Required files in the root directory
	required_files := {
		"README.md",
		"TERRAFORM-DOCS.md",
		"CODEOWNERS",
		"Makefile",
		"outputs.tf",
	}

	# Check if any required file is missing
	some file in required_files
	not file_exists(module_path, file)

	result := {
		"policy": "terraform_module_data_structure_policy",
		"severity": "error",
		"message": sprintf("Required file '%s' is missing in module root", [file]),
		"details": sprintf("Module '%s' must contain '%s' in its root directory", [module_path, file]),
		"resolution": sprintf("Create the missing '%s' file in the module root", [file]),
	}
}

violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Check if at least one *-data.tf file exists
	not has_data_tf_file(module_path)

	result := {
		"policy": "terraform_module_data_structure_policy",
		"severity": "error",
		"message": "At least one *-data.tf file is required",
		"details": sprintf("Module '%s' must contain at least one file matching pattern '*-data.tf'", [module_path]),
		"resolution": "Create at least one file with pattern '<name>-data.tf' (e.g., 's3-data.tf')",
	}
}

# Check for non-empty required files
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Files that cannot be empty
	non_empty_files := {
		"README.md",
		"TERRAFORM-DOCS.md",
		"CODEOWNERS",
		"Makefile",
		"outputs.tf",
	}

	# Check if any required file is empty
	some file in non_empty_files
	file_exists(module_path, file)
	file_is_empty(module_path, file)

	result := {
		"policy": "terraform_module_data_structure_policy",
		"severity": "error",
		"message": sprintf("Required file '%s' cannot be empty", [file]),
		"details": sprintf("Module '%s' contains an empty '%s' file", [module_path, file]),
		"resolution": sprintf("Add content to the '%s' file", [file]),
	}
}

violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Get all .tf files in the root
	tf_files := list_files(module_path)

	# Check if any *-data.tf file is empty
	some file in tf_files
	regex.match(`^[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*-data\.tf$`, file)
	file_is_empty(module_path, file)

	result := {
		"policy": "terraform_module_data_structure_policy",
		"severity": "error",
		"message": sprintf("Data file '%s' cannot be empty", [file]),
		"details": sprintf("Module '%s' contains an empty '%s' file", [module_path, file]),
		"resolution": sprintf("Add data source content to the '%s' file", [file]),
	}
}

# Check for only allowed .tf files in the root
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Get all .tf files in the root
	tf_files := list_files(module_path)

	# Check for disallowed .tf files
	some file in tf_files
	endswith(file, ".tf")
	not is_allowed_tf_file(file)

	result := {
		"policy": "terraform_module_data_structure_policy",
		"severity": "error",
		"message": sprintf("Disallowed .tf file '%s' in module root", [file]),
		"details": sprintf("Module '%s' contains '%s' which is not allowed. Only main.tf, variables.tf, versions.tf, outputs.tf, locals.tf, and *-data.tf files are permitted", [module_path, file]),
		"resolution": sprintf("Remove or rename '%s' to match allowed patterns", [file]),
	}
}

# Check for examples directory and required files
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Check if examples directory exists
	not dir_exists(module_path, "examples")

	result := {
		"policy": "terraform_module_data_structure_policy",
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
		"policy": "terraform_module_data_structure_policy",
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

has_data_tf_file(module_path) if {
	tf_files := list_files(module_path)
	some file in tf_files
	regex.match(`^[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*-data\.tf$`, file)
}

is_allowed_tf_file(file) if {
	file == "main.tf"
}

is_allowed_tf_file(file) if {
	file == "variables.tf"
}

is_allowed_tf_file(file) if {
	file == "versions.tf"
}

is_allowed_tf_file(file) if {
	file == "outputs.tf"
}

is_allowed_tf_file(file) if {
	file == "locals.tf"
}

is_allowed_tf_file(file) if {
	regex.match(`^[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*-data\.tf$`, file)
}
