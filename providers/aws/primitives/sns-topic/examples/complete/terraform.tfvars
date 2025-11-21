name              = "testing-terraform-monorepo-complete"
display_name      = "Complete SNS Topic Example"
signature_version = "2"
tracing_config    = "Active"
kms_master_key_id = "alias/aws/sns"
tags = {
  Environment     = "dev"
  Project         = "sns-complete-example"
  "caylent:owner" = "lucas.valor@caylent.com"
}
