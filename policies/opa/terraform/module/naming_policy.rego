package terraform.module.naming

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Check for dynamically generated resource names
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Get all .tf files in the module (excluding examples and tests)
	tf_files := {file |
		some path in object.keys(input.files)
		startswith(path, sprintf("%s/", [module_path]))
		endswith(path, ".tf")
		not contains(path, "/examples/")
		not contains(path, "/tests/")
		file := path
	}

	# Check each file for dynamic resource names
	some file in tf_files
	content := input.files[file]
	contains_dynamic_resource_name(content)

	result := {
		"policy": "terraform_module_naming_policy",
		"severity": "error",
		"message": "Dynamic resource name generation detected",
		"details": sprintf("File '%s' contains dynamically generated resource names", [file]),
		"resolution": "Use variables for resource names instead of dynamic generation",
	}
}

# Helper function to detect dynamic resource name generation
contains_dynamic_resource_name(content) if {
	# Look for resource blocks with dynamic names
	# This checks for interpolation in the resource name
	regex.match(`resource\s+"[^"]+"\s+"[${}]`, content)
}

contains_dynamic_resource_name(content) if {
	# Look for resource blocks with dynamic names using functions
	# This checks for common functions used in resource names
	regex.match(`resource\s+"[^"]+"\s+"[^"]*\b(concat|format|join|lower|upper|replace|substr|uuid|timestamp)\b`, content)
}
