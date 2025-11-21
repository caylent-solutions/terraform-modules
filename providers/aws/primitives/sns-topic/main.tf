resource "aws_sns_topic" "this" {
  name                        = var.name
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.content_based_deduplication
  kms_master_key_id           = var.kms_master_key_id
  delivery_policy             = var.delivery_policy

  http_success_feedback_role_arn           = var.enable_delivery_status_logging ? var.http_success_feedback_role_arn : null
  http_failure_feedback_role_arn           = var.enable_delivery_status_logging ? var.http_failure_feedback_role_arn : null
  http_success_feedback_sample_rate        = var.enable_delivery_status_logging ? var.http_success_feedback_sample_rate : null
  lambda_success_feedback_role_arn         = var.enable_delivery_status_logging ? var.lambda_success_feedback_role_arn : null
  lambda_failure_feedback_role_arn         = var.enable_delivery_status_logging ? var.lambda_failure_feedback_role_arn : null
  lambda_success_feedback_sample_rate      = var.enable_delivery_status_logging ? var.lambda_success_feedback_sample_rate : null
  sqs_success_feedback_role_arn            = var.enable_delivery_status_logging ? var.sqs_success_feedback_role_arn : null
  sqs_failure_feedback_role_arn            = var.enable_delivery_status_logging ? var.sqs_failure_feedback_role_arn : null
  sqs_success_feedback_sample_rate         = var.enable_delivery_status_logging ? var.sqs_success_feedback_sample_rate : null
  application_success_feedback_role_arn    = var.enable_delivery_status_logging ? var.application_success_feedback_role_arn : null
  application_failure_feedback_role_arn    = var.enable_delivery_status_logging ? var.application_failure_feedback_role_arn : null
  application_success_feedback_sample_rate = var.enable_delivery_status_logging ? var.application_success_feedback_sample_rate : null

  tags = var.tags
}

resource "aws_sns_topic_policy" "this" {
  count  = var.policy != null ? 1 : 0
  arn    = aws_sns_topic.this.arn
  policy = var.policy
}

