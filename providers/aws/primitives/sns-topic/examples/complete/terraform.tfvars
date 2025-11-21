name                                = "testing-terraform-monorepo-complete"
display_name                        = "Complete SNS Topic Example"
signature_version                   = "2"
tracing_config                      = "Active"
kms_master_key_id                   = "alias/aws/sns"
enable_delivery_status_logging      = true
lambda_success_feedback_role_arn    = "arn:aws:iam::179743357982:role/SNSSuccessFeedback"
lambda_failure_feedback_role_arn    = "arn:aws:iam::179743357982:role/SNSFailureFeedback"
lambda_success_feedback_sample_rate = 100
tags = {
  Environment     = "dev"
  Project         = "sns-complete-example"
  "caylent:owner" = "lucas.valor@caylent.com"
}
