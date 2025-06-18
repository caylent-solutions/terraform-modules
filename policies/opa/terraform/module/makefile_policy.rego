package terraform.module.makefile

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Check if Makefile matches the skeleton Makefile
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Check if Makefile exists
	file_exists(module_path, "Makefile")

	# Get the content of the module's Makefile
	module_makefile := input.files[sprintf("%s/Makefile", [module_path])]

	# Get the content of the skeleton Makefile
	skeleton_makefile := input.files["skeletons/generic-skeleton/Makefile"]

	# Check if they match
	module_makefile != skeleton_makefile

	result := {
		"policy": "terraform_module_makefile_policy",
		"severity": "error",
		"message": "Makefile does not match the skeleton Makefile",
		"details": sprintf("Module '%s' contains a Makefile that does not match the skeleton Makefile", [module_path]),
		"resolution": "Copy the Makefile from skeletons/generic-skeleton/Makefile",
	}
}

# Helper function
file_exists(module_path, file) if {
	input.files[sprintf("%s/%s", [module_path, file])]
}
