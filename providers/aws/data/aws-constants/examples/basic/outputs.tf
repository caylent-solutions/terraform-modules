# Direct module outputs for testing
output "iam_identity_center_principal_types" {
  description = "Valid principal types for IAM Identity Center"
  value       = module.aws_constants.iam_identity_center_principal_types
}

output "iam_identity_center_identity_provider_types" {
  description = "Valid identity provider types for IAM Identity Center"
  value       = module.aws_constants.iam_identity_center_identity_provider_types
}

output "iam_identity_center_permission_set_keys" {
  description = "Valid permission set configuration keys for IAM Identity Center"
  value       = module.aws_constants.iam_identity_center_permission_set_keys
}

output "iam_identity_center_policy_properties" {
  description = "Valid policy property names for IAM Identity Center"
  value       = module.aws_constants.iam_identity_center_policy_properties
}

output "aws_account_id_regex" {
  description = "Regular expression pattern for AWS Account ID validation"
  value       = module.aws_constants.aws_account_id_regex
}

output "array_indices" {
  description = "Common array index constants"
  value       = module.aws_constants.array_indices
}

output "defaults" {
  description = "Default values for common use cases"
  value       = module.aws_constants.defaults
}

output "format_strings" {
  description = "Common format string patterns"
  value       = module.aws_constants.format_strings
}

output "lambda_extension" {
  description = "AWS Parameters and Secrets Lambda Extension constants"
  value       = module.aws_constants.lambda_extension
}

# Grouped outputs for convenience
output "all_constants" {
  description = "All AWS constants from the module"
  value = {
    iam_identity_center = {
      principal_types         = module.aws_constants.iam_identity_center_principal_types
      identity_provider_types = module.aws_constants.iam_identity_center_identity_provider_types
      permission_set_keys     = module.aws_constants.iam_identity_center_permission_set_keys
      policy_properties       = module.aws_constants.iam_identity_center_policy_properties
    }
    general = {
      aws_account_id_regex = module.aws_constants.aws_account_id_regex
      array_indices        = module.aws_constants.array_indices
      defaults             = module.aws_constants.defaults
      format_strings       = module.aws_constants.format_strings
    }
    lambda = {
      extension = module.aws_constants.lambda_extension
    }
  }
}