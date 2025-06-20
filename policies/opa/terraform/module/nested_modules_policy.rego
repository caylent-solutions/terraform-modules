package terraform.module.nested

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Identify nested Terraform files
nested_files := [file |
	some file in object.keys(input.files)

	# Must start with the module path
	startswith(file, sprintf("%s/", [input.module_path]))

	# Strip the module path prefix to get relative file path
	rel := substring(file, count(input.module_path) + 1, -1)

	# Must be a .tf file
	endswith(file, ".tf")

	# Must be in a subdirectory (i.e., contain a slash)
	contains(rel, "/")

	# Exclude files in examples/ or tests/
	not startswith(rel, "examples/")
	not startswith(rel, "tests/")
]

# Violation: return a list explicitly
violation := [result] if {
	count(nested_files) > 0

	nested_files_str := concat("\n  - ", nested_files)

	result := {
		"policy": "terraform_module_nested_modules_policy",
		"severity": "error",
		"message": "Nested Terraform modules are not allowed",
		"details": sprintf("Root module: %s\nRelative repo path: %s\nFound %d nested Terraform files:\n  - %s", [input.module_path, input.repo_path, count(nested_files), nested_files_str]),
		"resolution": "Move Terraform files to the root of the module or restructure your code",
	}
}
