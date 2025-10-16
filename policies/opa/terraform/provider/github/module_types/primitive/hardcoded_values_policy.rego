package terraform.provider.github.module_types.primitive.hardcoded

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.hardcoded

# Re-export library violations
violation := hardcoded.violation
