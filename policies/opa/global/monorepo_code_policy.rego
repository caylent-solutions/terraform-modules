package monorepo.code

import future.keywords.in
import future.keywords.if

# Enforces that PRs modifying non-module files are allowed only if they do not touch any Terraform module folders
# Mixed changes across modules and non-modules are rejected
violation[result] {
    # Get configuration from input
    config := input.config
    module_roots := config.module_roots
    
    # Get changed files from input
    changed_files := input.changed_files
    count(changed_files) > 0
    
    # Separate module files from non-module files
    module_files := [file | file in changed_files; is_module_file(file, module_roots)]
    non_module_files := [file | file in changed_files; not is_module_file(file, module_roots)]
    
    # Violation if both module and non-module files are changed
    count(module_files) > 0
    count(non_module_files) > 0
    
    result := {
        "policy": "monorepo_code_policy",
        "severity": "error",
        "message": "PR mixes module and non-module changes",
        "details": sprintf("Found %d module files and %d non-module files", [count(module_files), count(non_module_files)]),
        "resolution": "Split your changes into separate PRs: one for module changes and one for non-module changes"
    }
}

# Helper function to determine if a file is within a module
is_module_file(file_path, module_roots) {
    some root in module_roots
    startswith(file_path, root)
}