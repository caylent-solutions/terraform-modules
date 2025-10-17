# Outputs for AWS Constants Data Module

output "iam_identity_center_principal_types" {
  description = "Valid principal types for IAM Identity Center"
  value       = local.iam_identity_center_principal_types
}

output "iam_identity_center_identity_provider_types" {
  description = "Valid identity provider types for IAM Identity Center"
  value       = local.iam_identity_center_identity_provider_types
}

output "iam_identity_center_permission_set_keys" {
  description = "Valid permission set configuration keys for IAM Identity Center"
  value       = local.iam_identity_center_permission_set_keys
}

output "iam_identity_center_policy_properties" {
  description = "Valid policy property names for IAM Identity Center"
  value       = local.iam_identity_center_policy_properties
}

output "aws_account_id_regex" {
  description = "Regular expression pattern for AWS Account ID validation"
  value       = local.aws_account_id_regex
}

output "array_indices" {
  description = "Common array index constants"
  value       = local.array_indices
}

output "defaults" {
  description = "Default values for common use cases"
  value       = local.defaults
}

output "format_strings" {
  description = "Common format string patterns"
  value       = local.format_strings
}