package terraform.module.makefile

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
        "policy": "terraform_module_makefile_policy",
        "severity": "error",
        "message": "Makefile does not match the skeleton Makefile",
        "details": sprintf("Module '%s' contains a Makefile that does not match the skeleton Makefile", [module_path]),
        "resolution": "Copy the Makefile from skeletons/generic-skeleton/Makefile"
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
        "policy": "terraform_module_makefile_policy",
        "severity": "error",
        "message": "Nested Terraform modules are not allowed",
        "details": sprintf("File '%s' indicates a nested module structure", [file]),
        "resolution": "Move Terraform files to the root of the module or restructure your code"
    }
}

# Helper function
file_exists(module_path, file) {
    input.files[sprintf("%s/%s", [module_path, file])]
}