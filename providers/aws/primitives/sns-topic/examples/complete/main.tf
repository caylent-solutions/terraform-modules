module "sns_topic" {
  source = "../../"

  name                                = var.name
  display_name                        = var.display_name
  signature_version                   = var.signature_version
  tracing_config                      = var.tracing_config
  kms_master_key_id                   = var.kms_master_key_id
  policy                              = var.policy
  enable_delivery_status_logging      = var.enable_delivery_status_logging
  lambda_success_feedback_role_arn    = var.lambda_success_feedback_role_arn
  lambda_failure_feedback_role_arn    = var.lambda_failure_feedback_role_arn
  lambda_success_feedback_sample_rate = var.lambda_success_feedback_sample_rate
  tags                                = var.tags
}
