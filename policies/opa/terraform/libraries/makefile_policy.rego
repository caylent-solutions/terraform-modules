package terraform.libraries.makefile

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

# 🔴 Violation if .cpmenv is missing
violation[result] if {
	module_path := input.module_path
	not file_exists(module_path, ".cpmenv")

	result := {
		"policy": "terraform_module_makefile_policy",
		"severity": "error",
		"message": ".cpmenv is missing from the module",
		"details": sprintf("Module '%s' does not contain a .cpmenv", [module_path]),
		"resolution": "Add a .cpmenv to your module that matches the skeleton",
	}
}

# 🔴 Violation if .cpmenv exists but doesn't match skeleton
violation[result] if {
	module_path := input.module_path
	file_exists(module_path, ".cpmenv")

	module_cpmenv := input.files[sprintf("%s/.cpmenv", [module_path])]
	skeleton_cpmenv := input.files["skeletons/generic-skeleton/.cpmenv"]

	module_cpmenv != skeleton_cpmenv

	result := {
		"policy": "terraform_module_makefile_policy",
		"severity": "error",
		"message": ".cpmenv does not match the skeleton .cpmenv",
		"details": sprintf("Module '%s' contains a .cpmenv that does not match the skeleton", [module_path]),
		"resolution": "Copy the .cpmenv from skeletons/generic-skeleton/.cpmenv",
	}
}

# ✅ Helper: Checks if a file exists in the input
file_exists(module_path, file) if {
	input.files[sprintf("%s/%s", [module_path, file])]
}
