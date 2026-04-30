resource "aws_sqs_queue" "dlq" {
  count = var.enable_dlq ? 1 : 0

  name                              = var.dlq_name
  message_retention_seconds         = var.dlq_message_retention_seconds
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  tags = local.common_tags
}

resource "aws_sqs_queue" "queue" {
  name                              = var.name
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  redrive_policy = var.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = local.common_tags

  depends_on = [aws_sqs_queue.dlq]
}

resource "aws_cloudwatch_metric_alarm" "dlq_depth" {
  count = var.enable_dlq && var.enable_dlq_alarm ? 1 : 0

  alarm_name          = var.dlq_alarm_name
  comparison_operator = var.dlq_alarm_comparison_operator
  evaluation_periods  = var.dlq_alarm_evaluation_periods
  metric_name         = var.dlq_alarm_metric_name
  namespace           = var.dlq_alarm_namespace
  period              = var.dlq_alarm_period_seconds
  statistic           = var.dlq_alarm_statistic
  threshold           = var.dlq_alarm_threshold
  alarm_description   = var.dlq_alarm_description
  alarm_actions       = var.dlq_alarm_actions
  ok_actions          = var.dlq_alarm_ok_actions

  dimensions = {
    QueueName = aws_sqs_queue.dlq[0].name
  }

  tags = local.common_tags
}
