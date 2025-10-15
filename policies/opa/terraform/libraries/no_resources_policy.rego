package terraform.libraries.no_resources

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Enforces that modules do not contain terraform resource blocks
violation[result] if {
	has_resource_blocks

	result := {
		"policy": "terraform_module_no_resources_policy",
		"severity": "error",
		"message": "Module cannot contain resource blocks",
		"details": "This module type should not define direct resources",
		"resolution": "Remove resource blocks from this module",
	}
}

# Helper to check if any .tf files contain resource blocks
has_resource_blocks if {
	files := input.terraform_files
	count(files) > 0
	some _, content in files
	contains(content, "resource \"")
}
