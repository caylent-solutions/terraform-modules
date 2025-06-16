package terraform.module.hardcoded

import future.keywords.in
import future.keywords.if

# Check for hard-coded values in Terraform files
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Get all .tf files in the module root (excluding examples and tests)
    tf_files := {file | 
        some path in object.keys(input.files)
        startswith(path, sprintf("%s/", [module_path]))
        endswith(path, ".tf")
        not contains(path, "/examples/")  # Allow hardcoded values in examples
        not contains(path, "/tests/")     # Allow hardcoded values in tests
        not endswith(path, "/variables.tf")  # Allow default values in variables.tf
        file := path
    }
    
    # Check each file for hard-coded values
    some file in tf_files
    content := input.files[file]
    contains_hardcoded_value(content)
    
    result := {
        "policy": "terraform_module_hardcoded_values_policy",
        "severity": "error",
        "message": "Terraform file contains hard-coded values",
        "details": sprintf("File '%s' contains hard-coded values which should be variables", [file]),
        "resolution": "Replace hard-coded values with variables or use variable interpolation ${var.name}"
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
}

# Also check for hardcoded numbers
contains_hardcoded_value(content) {
    # Look for attribute assignments with hardcoded numbers
    re_match(`\w+\s*=\s*\d+`, content)
}

# Check for hardcoded boolean values
contains_hardcoded_value(content) {
    # Look for attribute assignments with hardcoded boolean values
    re_match(`\w+\s*=\s*(true|false)`, content)
}

# Check for hardcoded JSON objects
contains_hardcoded_value(content) {
    # Look for attribute assignments with hardcoded JSON objects
    # Match patterns like: attribute = { key = "value" }
    re_match(`\w+\s*=\s*\{[^${}]*"[^${}][^"]*"[^}]*\}`, content)
}

# Check for hardcoded YAML heredocs
contains_hardcoded_value(content) {
    # Look for attribute assignments with hardcoded YAML heredocs
    # Match patterns like: attribute = <<YAML ... YAML
    re_match(`\w+\s*=\s*<<(YAML|YML)[^${}]*`, content)
}