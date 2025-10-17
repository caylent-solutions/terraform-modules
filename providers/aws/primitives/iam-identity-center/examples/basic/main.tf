
module "iam_identity_center" {
  source = "../.."

  sso_groups          = var.sso_groups
  permission_sets     = var.permission_sets
  account_assignments = var.account_assignments
}
