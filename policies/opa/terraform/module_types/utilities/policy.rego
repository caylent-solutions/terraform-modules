package terraform.module.utility

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Enforces that utility modules:
# - Do not contain terraform resource blocks
violation[result] if {
	# Check for resource blocks
	has_resource_blocks

	result := {
		"policy": "utility_module_policy",
		"severity": "error",
		"message": "Utility modules cannot contain resource blocks",
		"details": "Utility modules should only contain reusable code like locals and variables, not resources",
		"resolution": "Remove resource blocks from utility modules",
	}
}

# Helper to check if any .tf files contain resource blocks
has_resource_blocks if {
	files := input.terraform_files
	count(files) > 0
	some _, content in files
	contains(content, "resource \"")
}
