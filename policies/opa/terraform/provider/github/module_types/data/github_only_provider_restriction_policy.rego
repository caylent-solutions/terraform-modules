package terraform.provider.github.module_types.data.github_only_provider_restriction

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.github_only_provider_restriction

# Re-export library violations
violation := github_only_provider_restriction.violation
