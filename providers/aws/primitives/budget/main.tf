
resource "aws_budgets_budget" "this" {
  for_each = var.budgets

  name         = each.value.name
  budget_type  = each.value.budget_type
  limit_amount = each.value.limit_amount
  time_unit    = each.value.time_unit

  # Optionals
  account_id        = each.value.account_id
  limit_unit        = each.value.limit_unit
  time_period_start = each.value.time_period_start
  time_period_end   = each.value.time_period_end

  dynamic "auto_adjust_data" {
    for_each = each.value.auto_adjust_data != null ? try(tolist(each.value.auto_adjust_data), [
      each.value.auto_adjust_data
    ]) : []

    content {
      auto_adjust_type = auto_adjust_data.value.auto_adjust_type
      dynamic "historical_options" {
        for_each = auto_adjust_data.value.auto_adjust_type == "HISTORICAL" ? [auto_adjust_data.value.historical_options] : []

        content {
          budget_adjustment_period = historical_options.value.budget_adjustment_period
        }
      }
    }
  }

  dynamic "cost_types" {
    for_each = each.value.cost_types != null ? [each.value.cost_types] : []

    content {
      include_credit             = cost_types.value.include_credit
      include_discount           = cost_types.value.include_discount
      include_other_subscription = cost_types.value.include_other_subscription
      include_recurring          = cost_types.value.include_recurring
      include_refund             = cost_types.value.include_refund
      include_subscription       = cost_types.value.include_subscription
      include_support            = cost_types.value.include_support
      include_tax                = cost_types.value.include_tax
      include_upfront            = cost_types.value.include_upfront
      use_blended                = cost_types.value.use_blended
    }
  }

  dynamic "cost_filter" {
    for_each = each.value.cost_filter != null ? each.value.cost_filter : {}

    content {
      name   = cost_filter.key
      values = cost_filter.value
    }
  }

  dynamic "notification" {
    for_each = each.value.notification != null ? try(tolist(each.value.notification), [
      each.value.notification
    ]) : []

    content {
      comparison_operator        = notification.value.comparison_operator
      threshold                  = notification.value.threshold
      threshold_type             = notification.value.threshold_type
      notification_type          = notification.value.notification_type
      subscriber_sns_topic_arns  = notification.value.subscriber_sns_topic_arns
      subscriber_email_addresses = notification.value.subscriber_email_addresses
    }
  }

  tags = var.tags
}
