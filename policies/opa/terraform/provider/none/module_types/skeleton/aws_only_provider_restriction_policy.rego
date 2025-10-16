package terraform.provider.none.module_types.skeleton.aws_only_provider_restriction

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.aws_only_provider_restriction

# Re-export library violations
violation := aws_only_provider_restriction.violation
