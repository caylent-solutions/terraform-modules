package terraform.module.organization

import future.keywords.in
import future.keywords.if

# Check that variable declarations are only in variables.tf
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
        not endswith(path, "/variables.tf")
        file := path
    }
    
    # Check each file for variable declarations
    some file in tf_files
    content := input.files[file]
    re_match(`variable\s+"[^"]*"\s*{`, content)
    
    result := {
        "policy": "terraform_file_organization_policy",
        "severity": "error",
        "message": "Variable declarations must be in variables.tf",
        "details": sprintf("File '%s' contains variable declarations which should only be in variables.tf", [file]),
        "resolution": "Move all variable declarations to variables.tf"
    }
}

# Check that output declarations are only in outputs.tf
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
        not endswith(path, "/outputs.tf")
        file := path
    }
    
    # Check each file for output declarations
    some file in tf_files
    content := input.files[file]
    re_match(`output\s+"[^"]*"\s*{`, content)
    
    result := {
        "policy": "terraform_file_organization_policy",
        "severity": "error",
        "message": "Output declarations must be in outputs.tf",
        "details": sprintf("File '%s' contains output declarations which should only be in outputs.tf", [file]),
        "resolution": "Move all output declarations to outputs.tf"
    }
}

# Check that terraform and required_providers blocks are only in versions.tf
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
        not endswith(path, "/versions.tf")
        file := path
    }
    
    # Check each file for terraform blocks
    some file in tf_files
    content := input.files[file]
    re_match(`terraform\s*{`, content)
    
    result := {
        "policy": "terraform_file_organization_policy",
        "severity": "error",
        "message": "Terraform blocks must be in versions.tf",
        "details": sprintf("File '%s' contains terraform blocks which should only be in versions.tf", [file]),
        "resolution": "Move all terraform blocks to versions.tf"
    }
}

# Check that required_providers blocks are only in versions.tf
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
        not endswith(path, "/versions.tf")
        file := path
    }
    
    # Check each file for required_providers blocks
    some file in tf_files
    content := input.files[file]
    re_match(`required_providers\s*{`, content)
    
    result := {
        "policy": "terraform_file_organization_policy",
        "severity": "error",
        "message": "Required providers blocks must be in versions.tf",
        "details": sprintf("File '%s' contains required_providers blocks which should only be in versions.tf", [file]),
        "resolution": "Move all required_providers blocks to versions.tf"
    }
}

# Check that locals blocks are only in locals.tf
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
        not endswith(path, "/locals.tf")
        file := path
    }
    
    # Check each file for locals blocks
    some file in tf_files
    content := input.files[file]
    re_match(`locals\s*{`, content)
    
    result := {
        "policy": "terraform_file_organization_policy",
        "severity": "error",
        "message": "Locals blocks must be in locals.tf",
        "details": sprintf("File '%s' contains locals blocks which should only be in locals.tf", [file]),
        "resolution": "Move all locals blocks to locals.tf"
    }
}