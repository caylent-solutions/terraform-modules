terraform {
  required_version = ">= 1.12.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.82.0, < 6.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0.0, < 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0, < 4.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0, < 4.0.0"
    }
  }
}
