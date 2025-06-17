package terraform.module

import future.keywords.if
import future.keywords.in

# Evaluates if PR changes follow the single module policy
# - Add-only: new module folder and its contents only
# - Update-only: modify files inside exactly one existing module folder
# - Delete-only: delete one module folder and its contents only
violation[result] if {
	# Get configuration from input
	config := input.config
	module_roots := config.module_roots

	# Get changed files from input
	changed_files := input.changed_files
	count(changed_files) > 0

	# Extract module paths from changed files
	module_paths := get_affected_modules(changed_files, module_roots)

	# Violation if more than one module is affected
	count(module_paths) > 1

	result := {
		"policy": "terraform_module_policy",
		"severity": "error",
		"message": "PR modifies multiple Terraform modules",
		"details": sprintf("Changes affect %d modules: %s", [count(module_paths), concat(", ", module_paths)]),
		"resolution": "Split your changes into separate PRs, one per module",
	}
}

# Helper function to extract affected module paths from changed files
get_affected_modules(files, module_roots) := modules if {
	# For each file, find which module root it belongs to
	file_modules := {module_path |
		some file in files
		module_path := get_module_path(file, module_roots)
	}

	# Remove empty strings (files not in any module)
	modules := {path |
		some path in file_modules
		path != ""
	}
}

# Helper function to determine which module a file belongs to
get_module_path(file_path, module_roots) := module_path if {
	# Find the module root that is a prefix of the file path
	some root in module_roots
	startswith(file_path, root)

	# Extract the module path (root + first directory under root)
	parts := split(trim_prefix(file_path, root), "/")
	count(parts) > 0
	module_path := sprintf("%s%s", [root, parts[0]])
}

# Default return value for get_module_path
get_module_path(file_path, module_roots) := "" if {
	# This rule will be used if no other rule matches
	not any_root_matches(file_path, module_roots)
}

# Helper function to check if any root matches the file path
any_root_matches(file_path, module_roots) if {
	some root in module_roots
	startswith(file_path, root)
}
