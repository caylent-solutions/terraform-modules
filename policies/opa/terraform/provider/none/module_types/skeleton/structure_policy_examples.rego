package terraform.provider.none.module_types.skeleton.structure_examples

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.structure_examples

# Re-export library violations
violation := structure_examples.violation
