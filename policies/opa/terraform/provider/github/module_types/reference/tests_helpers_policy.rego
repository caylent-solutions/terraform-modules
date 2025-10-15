package terraform.provider.github.module_types.reference.tests_helpers

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.tests_helpers

# Re-export library violations
violation := tests_helpers.violation
