package terraform.module.source

import future.keywords.in
import future.keywords.if

# Check for local module sources
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Get all .tf files in the module (excluding examples and tests)
    tf_files := {file | 
        some path in object.keys(input.files)
        startswith(path, sprintf("%s/", [module_path]))
        endswith(path, ".tf")
        not contains(path, "/examples/")
        not contains(path, "/tests/")
        file := path
    }
    
    # Check each file for local module sources
    some file in tf_files
    content := input.files[file]
    contains_local_module_source(content)
    
    result := {
        "policy": "terraform_module_source_policy",
        "severity": "error",
        "message": "Local module source detected",
        "details": sprintf("File '%s' contains a reference to a local module source", [file]),
        "resolution": "Use remote module sources instead of local paths"
    }
}

# Check for missing version constraints in module sources
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Get all .tf files in the module (excluding examples and tests)
    tf_files := {file | 
        some path in object.keys(input.files)
        startswith(path, sprintf("%s/", [module_path]))
        endswith(path, ".tf")
        not contains(path, "/examples/")
        not contains(path, "/tests/")
        file := path
    }
    
    # Check each file for module sources without version constraints
    some file in tf_files
    content := input.files[file]
    
    # Find module blocks
    re_match(`module\s+"[^"]+"\s+{`, content)
    
    # Check if it has a source but no version
    contains(content, "source")
    not contains_version_constraint(content)
    
    result := {
        "policy": "terraform_module_source_policy",
        "severity": "error",
        "message": "Module source without version constraint",
        "details": sprintf("File '%s' contains a module source without a version constraint", [file]),
        "resolution": "Add a version constraint to all module sources"
    }
}

# Check for non-pinned versions in external modules
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Get all .tf files in the module (excluding examples and tests)
    tf_files := {file | 
        some path in object.keys(input.files)
        startswith(path, sprintf("%s/", [module_path]))
        endswith(path, ".tf")
        not contains(path, "/examples/")
        not contains(path, "/tests/")
        file := path
    }
    
    # Check each file for external module sources with non-pinned versions
    some file in tf_files
    content := input.files[file]
    
    # Find module blocks with external sources (not from caylent)
    re_match(`module\s+"[^"]+"\s+{`, content)
    contains(content, "source")
    not is_caylent_source(content)
    
    # Check if it has a non-pinned version
    contains(content, "version")
    not contains_pinned_version(content)
    
    result := {
        "policy": "terraform_module_source_policy",
        "severity": "error",
        "message": "External module with non-pinned version",
        "details": sprintf("File '%s' contains an external module with a non-pinned version constraint", [file]),
        "resolution": "Use pinned versions (exact version) for all external modules"
    }
}

# Helper functions
contains_local_module_source(content) {
    # Check for relative paths in module sources
    re_match(`source\s*=\s*"\.\.?/`, content)
}

contains_local_module_source(content) {
    # Check for absolute paths in module sources
    re_match(`source\s*=\s*"/`, content)
}

contains_version_constraint(content) {
    # Check for version constraint in module block
    re_match(`module\s+"[^"]+"\s+{[^}]*version\s*=`, content)
}

is_caylent_source(content) {
    # Check if source is from caylent GitHub or provider
    re_match(`source\s*=\s*"github.com/caylent-solutions/terraform-modules`, content)
}

is_caylent_source(content) {
    # Check if source is from caylent provider
    re_match(`source\s*=\s*"terraform.provider.solutions.caylent.com`, content)
}

contains_pinned_version(content) {
    # Check for pinned version (exact version)
    re_match(`version\s*=\s*"[0-9]+\.[0-9]+\.[0-9]+"`, content)
}