# This file violates multiple policies by containing hardcoded values,
# dynamic resource names, and content that should be in other files

terraform {
  required_version = ">= 1.0.0"  # Wrong version constraint
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"  # Non-pinned version
    }
  }
}

# Variables in wrong file (should be in variables.tf)
variable "hardcoded_name" {
  description = "This should be in variables.tf"
  type        = string
  default     = "hardcoded-value"
}

# Locals in wrong file (should be in locals.tf)
locals {
  hardcoded_content = "production-content"  # Hardcoded value
  hardcoded_path = "/tmp/hardcoded.txt"  # Hardcoded value
}

# Resource with dynamic name using concat function to trigger naming policy
resource "local_file" "${concat(["file-", timestamp()])}" {
  content  = "hardcoded file content"  # Hardcoded value
  filename = "/tmp/hardcoded-file.txt"  # Hardcoded value
}

# Another resource with hardcoded values
resource "local_file" "hardcoded_file" {
  content  = "another hardcoded content"  # Hardcoded value
  filename = "/tmp/another-hardcoded.txt"  # Hardcoded value
  
  file_permission = "0644"  # Hardcoded permission
}

# Module with local source (violates source policy)
module "local_module" {
  source = "../other-module"  # Local source
  input_value = "hardcoded-input"  # Hardcoded value
}

# Module with external source but no version constraint
module "external_module" {
  source = "terraform-aws-modules/vpc/aws"
  # Missing version constraint
  name = "hardcoded-vpc-name"  # Hardcoded value
}

# Output in wrong file (should be in outputs.tf)
output "file_content" {
  description = "This should be in outputs.tf"
  value       = local_file.hardcoded_file.content
}