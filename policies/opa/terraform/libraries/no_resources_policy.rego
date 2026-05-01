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

# Helper to check if any module-root .tf file contains resource blocks.
# Examples and tests are excluded because example fixtures legitimately
# need resource blocks to scaffold dependencies (IAM roles, certs, hosted
# zones) the consumer would supply in production. The same exclusion
# pattern is used by source_policy for the same reason.
has_resource_blocks if {
	some path in object.keys(input.terraform_files)
	endswith(path, ".tf")
	not contains(path, "/examples/")
	not contains(path, "/tests/")
	content := input.terraform_files[path]
	contains(content, "resource \"")
}
