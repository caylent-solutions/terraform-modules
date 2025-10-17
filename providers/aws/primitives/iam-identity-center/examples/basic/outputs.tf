output "account_assignment_data" {
  value       = module.iam_identity_center.account_assignment_data
  description = "Tuple containing account assignment data"

}

output "principals_and_assignments" {
  value       = module.iam_identity_center.principals_and_assignments
  description = "Map containing account assignment data"

}

output "sso_groups_ids" {
  value       = module.iam_identity_center.sso_groups_ids
  description = "A map of SSO groups ids created by this module"
}
