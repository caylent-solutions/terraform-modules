resource "aws_sqs_queue" "dlq" {
  count = var.create_dlq ? 1 : 0

  name                        = var.fifo_queue ? "${var.name}-dlq.fifo" : "${var.name}-dlq"
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue ? var.content_based_deduplication : null

  message_retention_seconds  = var.dlq_message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_master_key_id == null ? null : var.kms_data_key_reuse_period_seconds
  sqs_managed_sse_enabled           = var.kms_master_key_id == null ? var.sqs_managed_sse_enabled : null

  tags = var.tags
}

resource "aws_sqs_queue" "this" {
  name                        = var.fifo_queue ? "${var.name}.fifo" : var.name
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue ? var.content_based_deduplication : null

  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_master_key_id == null ? null : var.kms_data_key_reuse_period_seconds
  sqs_managed_sse_enabled           = var.kms_master_key_id == null ? var.sqs_managed_sse_enabled : null

  redrive_policy = var.create_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "dlq_depth" {
  count = var.create_dlq && var.create_dlq_depth_alarm ? 1 : 0

  alarm_name          = "${var.name}${local.alarm_name_suffix}"
  alarm_description   = format(local.alarm_description_format, var.name, var.dlq_depth_alarm_threshold)
  comparison_operator = local.alarm_comparison_operator
  evaluation_periods  = var.dlq_depth_alarm_evaluation_periods
  metric_name         = local.alarm_metric_name
  namespace           = local.alarm_namespace
  period              = var.dlq_depth_alarm_period_seconds
  statistic           = local.alarm_statistic
  threshold           = var.dlq_depth_alarm_threshold
  treat_missing_data  = local.alarm_treat_missing_data

  dimensions = {
    QueueName = aws_sqs_queue.dlq[0].name
  }

  alarm_actions = var.dlq_depth_alarm_actions
  ok_actions    = var.dlq_depth_alarm_ok_actions

  tags = var.tags
}
