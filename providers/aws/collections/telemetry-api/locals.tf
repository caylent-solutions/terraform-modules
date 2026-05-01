locals {
  custom_domain_record_count = var.custom_domain_name == null ? 0 : 1

  alias_evaluate_target_health = !true
  alias_record_type            = join("", ["A"])
}
