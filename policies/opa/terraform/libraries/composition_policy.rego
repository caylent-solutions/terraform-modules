package terraform.libraries.composition

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Enforces that composition modules (collection/reference):
# - Do not contain terraform resource blocks
# - Require at least one source terraform module
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

violation[result] if {
	# Check for at least one module source
	not has_module_sources

	result := {
		"policy": "terraform_module_composition_policy",
		"severity": "error",
		"message": "Composition modules must use at least one source module",
		"details": "Modules should compose functionality from other modules",
		"resolution": "Add at least one module source to your module",
	}
}

# Helper to check if any .tf files contain resource blocks
has_resource_blocks if {
	some _, content in input.terraform_files
	contains(content, "resource \"")
}

# Helper to check if any .tf files contain module sources
has_module_sources if {
	some _, content in input.terraform_files
	contains(content, "module \"")
}
