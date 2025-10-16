package terraform.provider.github.module_types.collection.tests

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.tests

# Re-export library violations
violation := tests.violation
