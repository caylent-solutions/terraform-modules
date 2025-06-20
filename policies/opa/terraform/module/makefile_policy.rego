package terraform.module.makefile

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# 🔴 Violation if Makefile is missing
violation[result] if {
	module_path := input.module_path
	not file_exists(module_path, "Makefile")

	result := {
		"policy": "terraform_module_makefile_policy",
		"severity": "error",
		"message": "Makefile is missing from the module",
		"details": sprintf("Module '%s' does not contain a Makefile", [module_path]),
		"resolution": "Add a Makefile to your module that matches the skeleton",
	}
}

# 🔴 Violation if Makefile exists but doesn't match skeleton
violation[result] if {
	module_path := input.module_path
	file_exists(module_path, "Makefile")

	module_makefile := input.files[sprintf("%s/Makefile", [module_path])]
	skeleton_makefile := input.files["skeletons/generic-skeleton/Makefile"]

	module_makefile != skeleton_makefile

	result := {
		"policy": "terraform_module_makefile_policy",
		"severity": "error",
		"message": "Makefile does not match the skeleton Makefile",
		"details": sprintf("Module '%s' contains a Makefile that does not match the skeleton", [module_path]),
		"resolution": "Copy the Makefile from skeletons/generic-skeleton/Makefile",
	}
}

# ✅ Helper: Checks if a file exists in the input
file_exists(module_path, file) if {
	input.files[sprintf("%s/%s", [module_path, file])]
}
