package terraform.provider.github.module_types.collection.source

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.source

# Re-export library violations
violation := source.violation
