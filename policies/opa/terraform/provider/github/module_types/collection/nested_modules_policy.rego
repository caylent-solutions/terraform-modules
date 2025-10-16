package terraform.provider.github.module_types.collection.nested_modules

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.nested_modules

# Re-export library violations
violation := nested_modules.violation
