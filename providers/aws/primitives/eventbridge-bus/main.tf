resource "aws_cloudwatch_event_bus" "this" {
  name               = var.name
  kms_key_identifier = var.kms_key_identifier

  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = var.rules

  name           = each.value.name
  description    = each.value.description
  event_bus_name = aws_cloudwatch_event_bus.this.name
  event_pattern  = each.value.event_pattern
  state          = lookup(each.value, "state", local.rule_state_enabled)

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = var.targets

  event_bus_name = aws_cloudwatch_event_bus.this.name
  rule           = aws_cloudwatch_event_rule.this[each.value.rule_key].name
  target_id      = each.value.target_id
  arn            = each.value.arn
  role_arn       = lookup(each.value, "role_arn", null)
  input          = lookup(each.value, "input", null)
  input_path     = lookup(each.value, "input_path", null)

  dynamic "input_transformer" {
    for_each = lookup(each.value, "input_transformer", null) == null ? [] : [each.value.input_transformer]
    content {
      input_paths    = lookup(input_transformer.value, "input_paths", null)
      input_template = input_transformer.value.input_template
    }
  }

  dynamic "dead_letter_config" {
    for_each = lookup(each.value, "dlq_arn", null) == null ? [] : [each.value.dlq_arn]
    content {
      arn = dead_letter_config.value
    }
  }

  dynamic "retry_policy" {
    for_each = lookup(each.value, "retry_policy", null) == null ? [] : [each.value.retry_policy]
    content {
      maximum_event_age_in_seconds = retry_policy.value.maximum_event_age_in_seconds
      maximum_retry_attempts       = retry_policy.value.maximum_retry_attempts
    }
  }
}
