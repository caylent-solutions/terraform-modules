package terraform.module.structure

import future.keywords.in
import future.keywords.if

# Check if Makefile matches the skeleton Makefile
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Check if Makefile exists
    file_exists(module_path, "Makefile")
    
    # Get the content of the module's Makefile
    module_makefile := input.files[sprintf("%s/Makefile", [module_path])]
    
    # Get the content of the skeleton Makefile
    skeleton_makefile := input.files["skeletons/generic-skeleton/Makefile"]
    
    # Check if they match
    module_makefile != skeleton_makefile
    
    result := {
        "policy": "terraform_module_structure_policy",
        "severity": "error",
        "message": "Makefile does not match the skeleton Makefile",
        "details": sprintf("Module '%s' contains a Makefile that does not match the skeleton Makefile", [module_path]),
        "resolution": "Copy the Makefile from skeletons/generic-skeleton/Makefile"
    }
}

# Check for hard-coded values in Terraform files
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Get all .tf files in the module root (excluding examples and tests)
    tf_files := {file | 
        some path in object.keys(input.files)
        startswith(path, sprintf("%s/", [module_path]))
        endswith(path, ".tf")
        not contains(path, "/examples/")
        not contains(path, "/tests/")
        file := path
    }
    
    # Check each file for hard-coded values
    some file in tf_files
    content := input.files[file]
    contains_hardcoded_value(content)
    
    result := {
        "policy": "terraform_module_structure_policy",
        "severity": "error",
        "message": "Terraform file contains hard-coded values",
        "details": sprintf("File '%s' contains hard-coded values which should be variables", [file]),
        "resolution": "Replace hard-coded values with variables or use variable interpolation ${var.name}"
    }
}

# Check for nested modules
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Check for .tf files in subdirectories (excluding examples and tests)
    some file in object.keys(input.files)
    startswith(file, sprintf("%s/", [module_path]))
    endswith(file, ".tf")
    
    # Extract the relative path within the module
    rel_path := substring(file, count(module_path) + 1, -1)
    
    # Check if it's in a subdirectory but not in examples or tests
    contains(rel_path, "/")
    not startswith(rel_path, "/examples/")
    not startswith(rel_path, "/tests/")
    
    result := {
        "policy": "terraform_module_structure_policy",
        "severity": "error",
        "message": "Nested Terraform modules are not allowed",
        "details": sprintf("File '%s' indicates a nested module structure", [file]),
        "resolution": "Move Terraform files to the root of the module or restructure your code"
    }
}

# Helper functions to detect hard-coded values in Terraform code
contains_hardcoded_value(content) {
    # Look for resource blocks with hard-coded string values
    # Match attribute assignments in resource blocks that don't use variable interpolation
    re_match(`resource\s+"[^"]+"\s+"[^"]+"\s+{[^}]*\w+\s*=\s*"[^${}][^"]*"[^}]*}`, content)
}

contains_hardcoded_value(content) {
    # Look for attribute assignments with hardcoded string values
    # Exclude variable references (${var.name}), local references (${local.name}),
    # and other interpolation expressions
    re_match(`\w+\s*=\s*"[^${}][^"]*"`, content)
    not re_match(`variable\s+`, content)  # Exclude variable declarations
    not re_match(`locals\s+`, content)    # Exclude locals blocks
    not re_match(`output\s+`, content)    # Exclude output blocks
}

# Also check for hardcoded numbers
contains_hardcoded_value(content) {
    # Look for attribute assignments with hardcoded numbers
    # Exclude variable declarations, locals blocks, and output blocks
    re_match(`\w+\s*=\s*\d+`, content)
    not re_match(`variable\s+`, content)
    not re_match(`locals\s+`, content)
    not re_match(`output\s+`, content)
}

# Check for hardcoded boolean values
contains_hardcoded_value(content) {
    # Look for attribute assignments with hardcoded boolean values
    # Exclude variable declarations, locals blocks, and output blocks
    re_match(`\w+\s*=\s*(true|false)`, content)
    not re_match(`variable\s+`, content)
    not re_match(`locals\s+`, content)
    not re_match(`output\s+`, content)
}

# Check for hardcoded JSON objects
contains_hardcoded_value(content) {
    # Look for attribute assignments with hardcoded JSON objects
    # Match patterns like: attribute = { key = "value" }
    re_match(`\w+\s*=\s*\{[^${}]*"[^${}][^"]*"[^}]*\}`, content)
    not re_match(`variable\s+`, content)
    not re_match(`locals\s+`, content)
    not re_match(`output\s+`, content)
}

# Check for hardcoded YAML heredocs
contains_hardcoded_value(content) {
    # Look for attribute assignments with hardcoded YAML heredocs
    # Match patterns like: attribute = <<YAML ... YAML
    re_match(`\w+\s*=\s*<<(YAML|YML)[^${}]*`, content)
    not re_match(`variable\s+`, content)
    not re_match(`locals\s+`, content)
    not re_match(`output\s+`, content)
}