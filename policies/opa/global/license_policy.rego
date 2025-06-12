package terraform.module.license

import future.keywords.in
import future.keywords.if

# Check for additional license files or statements
violation[result] {
    # Get all files in the repository
    all_files := object.keys(input.files)
    
    # Check for LICENSE files other than the root LICENSE
    some file in all_files
    endswith(file, "LICENSE") or endswith(file, "License") or endswith(file, "license")
    file != "LICENSE"  # Exclude the root LICENSE file
    
    result := {
        "policy": "license_policy",
        "severity": "error",
        "message": "Additional LICENSE files are not allowed",
        "details": sprintf("Found additional LICENSE file: %s", [file]),
        "resolution": "Remove the additional LICENSE file. Only the Apache 2.0 license at the repository root is allowed."
    }
}

# Check for license statements in files
violation[result] {
    # Get all files in the repository
    all_files := object.keys(input.files)
    
    # Check for license statements in files
    some file in all_files
    content := input.files[file]
    
    # Look for common license statement patterns
    re_match(`(?i)(license|copyright|all rights reserved|permission is hereby granted)`, content)
    re_match(`(?i)(mit license|apache license|gnu|gpl|lgpl|bsd|mozilla|mpl)`, content)
    
    # Exclude the root LICENSE file
    file != "LICENSE"
    
    result := {
        "policy": "license_policy",
        "severity": "error",
        "message": "Additional license statements are not allowed",
        "details": sprintf("Found license statement in file: %s", [file]),
        "resolution": "Remove the license statement. Only the Apache 2.0 license at the repository root is allowed."
    }
}