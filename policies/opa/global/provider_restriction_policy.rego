package terraform.module.providers

import future.keywords.in
import future.keywords.if

# Check for disallowed cloud providers
violation[result] {
    # Get module path from input
    module_path := input.module_path
    
    # Get all .tf files in the module
    tf_files := {file | 
        some path in object.keys(input.files)
        startswith(path, sprintf("%s/", [module_path]))
        endswith(path, ".tf")
        file := path
    }
    
    # Disallowed cloud providers
    disallowed_providers := [
        "azurerm",
        "google",
        "google-beta",
        "azuread"
    ]
    
    # Check each file for disallowed providers
    some file in tf_files
    content := input.files[file]
    some provider in disallowed_providers
    contains(content, sprintf("\"%s\"", [provider]))
    
    result := {
        "policy": "provider_restriction_policy",
        "severity": "error",
        "message": sprintf("Disallowed cloud provider detected: %s", [provider]),
        "details": sprintf("File %s contains reference to %s provider. Only AWS is allowed among major cloud providers.", [file, provider]),
        "resolution": "Remove the disallowed provider and use AWS resources instead"
    }
}