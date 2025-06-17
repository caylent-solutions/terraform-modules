package terraform.module.reference

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Enforces that reference modules:
# - Do not contain terraform resource blocks
# - Require at least one source terraform module
violation[result] if {
	# Check for resource blocks
	has_resource_blocks

	result := {
		"policy": "reference_module_policy",
		"severity": "error",
		"message": "Reference modules cannot contain resource blocks",
		"details": "Reference modules should only use modules, not direct resources",
		"resolution": "Replace resource blocks with appropriate module references",
	}
}

violation[result] if {
	# Check for at least one module source
	not has_module_sources

	result := {
		"policy": "reference_module_policy",
		"severity": "error",
		"message": "Reference modules must use at least one source module",
		"details": "Reference modules should compose functionality from other modules",
		"resolution": "Add at least one module source to your reference module",
	}
}

# Helper to check if any .tf files contain resource blocks
has_resource_blocks if {
	files := input.terraform_files
	count(files) > 0
	some _, content in files
	contains(content, "resource \"")
}

# Helper to check if any .tf files contain module sources
has_module_sources if {
	files := input.terraform_files
	count(files) > 0
	some _, content in files
	contains(content, "module \"")
}
