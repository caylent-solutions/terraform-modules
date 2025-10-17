# General AWS Constants
# These are standard AWS patterns and formats

locals {
  # AWS Account ID format validation
  aws_account_id_regex = "[0-9]{12}"

  # Common array indices
  array_indices = {
    first = 0
  }

  # Default values
  defaults = {
    empty_map = {}
  }

  # Common format strings
  format_strings = {
    user_group_mapping    = "%s_%s"
    assignment_key_format = "Type:%s__Principal:%s__Permission:%s__Account:%s"
  }
}