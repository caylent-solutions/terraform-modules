package terraform.libraries.composition

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Enforces that composition modules (collection/reference):
# - Do not contain terraform resource blocks
violation[result] if {
	# Check for resource blocks
	has_resource_blocks

	result := {
		"policy": "terraform_module_composition_policy",
		"severity": "error",
		"message": "Composition modules cannot contain resource blocks",
		"details": "Modules that compose other modules should not define direct resources",
		"resolution": "Replace resource blocks with appropriate module references",
	}
}

# Helper to check if any .tf files contain resource blocks
has_resource_blocks if {
	some _, content in input.terraform_files
	contains(content, "resource \"")
}
