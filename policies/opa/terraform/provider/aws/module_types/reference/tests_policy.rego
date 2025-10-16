package terraform.provider.aws.module_types.reference.tests

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.tests

# Re-export library violations
violation := tests.violation
