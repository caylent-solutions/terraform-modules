sso_groups = {
  Admin = {
    group_name        = "Admin"
    group_description = "Admin Group"
  },
  Billing = {
    group_name        = "Billing"
    group_description = "Billing Group"
  },
}

existing_sso_users = {
  "jeronimo.orlando" = {
    user_name        = "jeronimo.orlando@caylent.com"
    group_membership = ["Admin"]
  }
  "nicolas.diaz" = {
    user_name        = "nicolas.diaz@caylent.com"
    group_membership = ["Billing"]
  }
}

account_assignments = {
  Admin = {
    principal_name = "Admin"
    principal_type = "GROUP"
    principal_idp  = "INTERNAL"
    permission_sets = [
      "AdministratorAccess",
      "Billing"
    ]
    account_ids = ["014498644125"]
  },
  Billing = {
    principal_name = "Billing"
    principal_type = "GROUP"
    principal_idp  = "INTERNAL"
    permission_sets = [
      "Billing",
    ]
    account_ids = ["014498644125"]
  }
}

permission_sets = {
  AdministratorAccess = {
    description = "AdministratorAccess"
    tags        = { ManagedBy = "Terraform" }
    aws_managed_policies = [
      "arn:aws:iam::aws:policy/IAMFullAccess",
      "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess",
      "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    ]
    customer_managed_policies = []
    permission_boundary       = []
  },
  Billing = {
    description = "Billing"
    tags        = { ManagedBy = "Terraform" }
    aws_managed_policies = [
      "arn:aws:iam::aws:policy/PowerUserAccess",
      "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
    ]
    customer_managed_policies = []
    permission_boundary       = []
  }
}