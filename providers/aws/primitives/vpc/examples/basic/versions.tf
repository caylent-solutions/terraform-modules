terraform {
  required_version = ">= 1.12.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0.0"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}