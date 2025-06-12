package terraform.module.tests

import future.keywords.in
import future.keywords.if

# Check for test directories matching example directories
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Get all example directories
    example_dirs := {dir | 
        some file in object.keys(input.files)
        startswith(file, sprintf("%s/examples/", [module_path]))
        parts := split(substring(file, count(sprintf("%s/examples/", [module_path])), -1), "/")
        count(parts) > 0
        dir := parts[0]
    }
    
    # Check if tests directory exists
    dir_exists(module_path, "tests")
    
    # Check if each example has a corresponding test directory
    some example_dir in example_dirs
    not dir_exists(module_path, sprintf("tests/%s", [example_dir]))
    
    result := {
        "policy": "terraform_module_tests_policy",
        "severity": "error",
        "message": sprintf("Missing test directory for example '%s'", [example_dir]),
        "details": sprintf("Module '%s' must contain a 'tests/%s' directory for the example '%s'", [module_path, example_dir, example_dir]),
        "resolution": sprintf("Create a 'tests/%s' directory with module_test.go and README.md files", [example_dir])
    }
}

# Check for common test directory if there are multiple examples
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Get all example directories
    example_dirs := {dir | 
        some file in object.keys(input.files)
        startswith(file, sprintf("%s/examples/", [module_path]))
        parts := split(substring(file, count(sprintf("%s/examples/", [module_path])), -1), "/")
        count(parts) > 0
        dir := parts[0]
    }
    
    # Check if there are multiple examples but no common test directory
    count(example_dirs) > 1
    not dir_exists(module_path, "tests/common")
    
    result := {
        "policy": "terraform_module_tests_policy",
        "severity": "error",
        "message": "Missing 'common' test directory for multiple examples",
        "details": sprintf("Module '%s' has multiple examples but no 'tests/common' directory", [module_path]),
        "resolution": "Create a 'tests/common' directory with module_test.go and README.md files"
    }
}

# Check for required files in each test directory
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Get all test directories
    test_dirs := {dir | 
        some file in object.keys(input.files)
        startswith(file, sprintf("%s/tests/", [module_path]))
        parts := split(substring(file, count(sprintf("%s/tests/", [module_path])), -1), "/")
        count(parts) > 0
        dir := parts[0]
    }
    
    # Required files in each test directory
    required_test_files := {
        "module_test.go",
        "README.md"
    }
    
    # Check if any required file is missing in any test directory
    some dir in test_dirs
    some file in required_test_files
    not test_file_exists(module_path, dir, file)
    
    result := {
        "policy": "terraform_module_tests_policy",
        "severity": "error",
        "message": sprintf("Required file '%s' is missing in test directory '%s'", [file, dir]),
        "details": sprintf("Test directory 'tests/%s' in module '%s' must contain '%s'", [dir, module_path, file]),
        "resolution": sprintf("Create the missing '%s' file in the 'tests/%s' directory", [file, dir])
    }
}

# Check for README.md in tests directory
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Check if tests directory exists
    dir_exists(module_path, "tests")
    
    # Check if README.md exists in tests directory
    not file_exists(module_path, "tests/README.md")
    
    result := {
        "policy": "terraform_module_tests_policy",
        "severity": "error",
        "message": "Missing README.md in tests directory",
        "details": sprintf("Module '%s' must contain a README.md file in the tests directory", [module_path]),
        "resolution": "Create a README.md file in the tests directory"
    }
}

# Check for non-empty required files in tests
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Get all test directories
    test_dirs := {dir | 
        some file in object.keys(input.files)
        startswith(file, sprintf("%s/tests/", [module_path]))
        parts := split(substring(file, count(sprintf("%s/tests/", [module_path])), -1), "/")
        count(parts) > 0
        dir := parts[0]
    }
    
    # Files that cannot be empty in test directories
    non_empty_test_files := {
        "module_test.go",
        "README.md"
    }
    
    # Check if any required file is empty in any test directory
    some dir in test_dirs
    some file in non_empty_test_files
    test_file_exists(module_path, dir, file)
    test_file_is_empty(module_path, dir, file)
    
    result := {
        "policy": "terraform_module_tests_policy",
        "severity": "error",
        "message": sprintf("Required file '%s' in test directory '%s' cannot be empty", [file, dir]),
        "details": sprintf("Test directory 'tests/%s' in module '%s' contains an empty '%s' file", [dir, module_path, file]),
        "resolution": sprintf("Add content to the '%s' file in the 'tests/%s' directory", [file, dir])
    }
}

# Check if tests/README.md is empty
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Check if README.md in tests directory is empty
    file_exists(module_path, "tests/README.md")
    file_is_empty(module_path, "tests/README.md")
    
    result := {
        "policy": "terraform_module_tests_policy",
        "severity": "error",
        "message": "README.md in tests directory cannot be empty",
        "details": sprintf("Module '%s' contains an empty README.md file in the tests directory", [module_path]),
        "resolution": "Add content to the README.md file in the tests directory"
    }
}

# Check for terraform-terratest-framework import in test files
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Get all test files
    test_files := {file | 
        some path in object.keys(input.files)
        startswith(path, sprintf("%s/tests/", [module_path]))
        endswith(path, "/module_test.go")
        file := path
    }
    
    # Check if any test file doesn't import the framework
    some file in test_files
    content := input.files[file]
    count(content) > 0
    not contains(content, "github.com/caylent-solutions/terraform-terratest-framework")
    
    result := {
        "policy": "terraform_module_tests_policy",
        "severity": "error",
        "message": "Missing terraform-terratest-framework import",
        "details": sprintf("Test file '%s' must import the Terraform Terratest Framework", [file]),
        "resolution": "Import the framework using 'github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx'"
    }
}

# Check for go.mod file with terraform-terratest-framework dependency
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Check if go.mod exists
    go_mod_file := sprintf("%s/go.mod", [module_path])
    not input.files[go_mod_file]
    
    result := {
        "policy": "terraform_module_tests_policy",
        "severity": "error",
        "message": "Missing go.mod file",
        "details": sprintf("Module '%s' must contain a go.mod file with terraform-terratest-framework dependency", [module_path]),
        "resolution": "Create a go.mod file with the terraform-terratest-framework dependency"
    }
}

# Check if go.mod contains terraform-terratest-framework
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Check if go.mod exists and contains the framework
    go_mod_file := sprintf("%s/go.mod", [module_path])
    input.files[go_mod_file]
    content := input.files[go_mod_file]
    not contains(content, "github.com/caylent-solutions/terraform-terratest-framework")
    
    result := {
        "policy": "terraform_module_tests_policy",
        "severity": "error",
        "message": "Missing terraform-terratest-framework dependency",
        "details": sprintf("Module '%s' go.mod file must include the terraform-terratest-framework dependency", [module_path]),
        "resolution": "Add 'github.com/caylent-solutions/terraform-terratest-framework' to the go.mod file"
    }
}

# Helper functions
dir_exists(module_path, dir) {
    some file in object.keys(input.files)
    startswith(file, sprintf("%s/%s/", [module_path, dir]))
}

file_exists(module_path, file) {
    input.files[sprintf("%s/%s", [module_path, file])]
}

file_is_empty(module_path, file) {
    content := input.files[sprintf("%s/%s", [module_path, file])]
    count(trim_space(content)) == 0
}

test_file_exists(module_path, test_dir, file) {
    input.files[sprintf("%s/tests/%s/%s", [module_path, test_dir, file])]
}

test_file_is_empty(module_path, test_dir, file) {
    content := input.files[sprintf("%s/tests/%s/%s", [module_path, test_dir, file])]
    count(trim_space(content)) == 0
}