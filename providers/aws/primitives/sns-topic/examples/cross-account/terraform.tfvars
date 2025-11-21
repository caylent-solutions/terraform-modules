name                 = "testing-terraform-monorepo-cross-account"
allowed_aws_accounts = ["123456789012", "987654321098"]
kms_master_key_id    = "alias/aws/sns"
tags = {
  Environment     = "dev"
  Project         = "sns-cross-account-example"
  "caylent:owner" = "lucas.valor@caylent.com"
}
