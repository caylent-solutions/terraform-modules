package terraform.module.test

import data.terraform.module as policy
import data.tests.opa.unit.helpers as helpers

# Test that changes to multiple modules violate the policy
test_multiple_modules_violation if {
    # Mock input with changes to multiple modules
    changed_files := [
        "modules/module1/main.tf",
        "modules/module2/variables.tf"
    ]
    config := {
        "module_roots": ["modules/"]
    }
    test_input := {
        "changed_files": changed_files,
        "config": config
    }
    
    # Check for violations
    violations := policy.violation with input as test_input
    
    # Expect one violation
    count(violations) == 1
}

# Test that changes to a single module pass the policy
test_single_module_no_violation if {
    # Mock input with changes to a single module
    changed_files := [
        "modules/module1/main.tf",
        "modules/module1/variables.tf",
        "modules/module1/outputs.tf"
    ]
    config := {
        "module_roots": ["modules/"]
    }
    test_input := {
        "changed_files": changed_files,
        "config": config
    }
    
    # Check for violations
    violations := policy.violation with input as test_input
    
    # Expect no violations
    count(violations) == 0
}

# Test that changes to non-module files pass the policy
test_non_module_files_no_violation if {
    # Mock input with changes to non-module files
    changed_files := [
        "README.md",
        "docs/usage.md"
    ]
    config := {
        "module_roots": ["modules/"]
    }
    test_input := {
        "changed_files": changed_files,
        "config": config
    }
    
    # Check for violations
    violations := policy.violation with input as test_input
    
    # Expect no violations
    count(violations) == 0
}

# Test with multiple module roots
test_multiple_module_roots if {
    # Mock input with changes to modules in different roots
    changed_files := [
        "modules/aws/module1/main.tf",
        "modules/gcp/module2/variables.tf"
    ]
    config := {
        "module_roots": ["modules/aws/", "modules/gcp/"]
    }
    test_input := {
        "changed_files": changed_files,
        "config": config
    }
    
    # Check for violations
    violations := policy.violation with input as test_input
    
    # Expect one violation
    count(violations) == 1
}