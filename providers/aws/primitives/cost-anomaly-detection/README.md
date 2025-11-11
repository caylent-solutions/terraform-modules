# AWS Cost Anomaly Detection Terraform Module

This Terraform module creates AWS Cost Anomaly Detection resources to monitor and alert on unusual spending patterns in your AWS account.

## What This Module Creates

- **Cost Anomaly Monitor**: Tracks spending patterns for your AWS services
- **Cost Anomaly Subscription**: Sends email notifications when spending anomalies are detected

## Basic Setup

### Minimal Configuration

```hcl
module "cost_anomaly_detection" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/cost-anomaly-detection?ref=providers/aws/primitives/cost-anomaly-detection/v1.0.0"

  name = "my-cost-monitor"
  
  subscribers = [
    {
      type    = "EMAIL"
      address = "admin@example.com"
    }
  ]
}
```

### Service-Specific Monitoring

```hcl
module "ec2_cost_monitor" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/cost-anomaly-detection?ref=providers/aws/primitives/cost-anomaly-detection/v1.0.0"

  name         = "ec2-cost-monitor"
  monitor_type = "DIMENSIONAL"
  
  monitor_specification = {
    dimension_key = "SERVICE"
    match_options = ["EQUALS"]
    values        = ["EC2-Instance"]
  }
  
  subscribers = [
    {
      type    = "EMAIL"
      address = "devops@example.com"
    }
  ]
  
  threshold_amount = 200
}
```

## Key Configuration Options

|        Variable          |        Description         |     Default     | Required |
|--------------------------|----------------------------|-----------------|----------|
| `name`                   | Base name for resources    | -               |    ✅    |
| `subscribers`            | Email addresses for alerts | `[]`            |    ✅    |
| `threshold_amount`       | Alert threshold in USD     | `100`           |    ❌    |
| `monitor_type`           | Monitor type               | `"DIMENSIONAL"` |    ❌    |
| `subscription_frequency` | Alert frequency            | `"DAILY"`       |    ❌    |

## Common Monitor Types

- **All Services**: Leave `monitor_specification` as `null` (default)
- **Specific Service**: Set `dimension_key = "SERVICE"` and specify service names
- **Account Level**: Set `dimension_key = "LINKED_ACCOUNT"` for multi-account setups

## Requirements

- AWS provider >= 5.0
- Terraform >= 1.12.1
- Valid email addresses for notifications

## Examples

- [Basic Setup](./examples/basic/) - Simple cost monitoring
- [Advanced Setup](./examples/advanced/) - Service-specific monitoring

## Outputs

- `anomaly_monitor_arn` - Monitor ARN for reference
- `anomaly_subscription_arn` - Subscription ARN (if created)

---

## Engineer Implementation Guide

### Shortcut: Quick Project Generation

```bash
# Generate complete customer project structure
make generate-project PROJECT_DIR=my-customer-project
cd my-customer-project

# Edit terraform.tfvars with customer details
# Then deploy
terraform init
terraform plan
terraform apply
```

### Step-by-Step Customer Project Setup

#### 1. Project Initialization
```bash
mkdir customer-aws-infrastructure
cd customer-aws-infrastructure
terraform init
```

#### 2. Main Configuration (`main.tf`)
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "cost_monitoring" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/cost-anomaly-detection?ref=providers/aws/primitives/cost-anomaly-detection/v1.0.0"

  name = "${var.customer_name}-cost-monitor"
  
  subscribers = [
    {
      type    = "EMAIL"
      address = var.finance_email
    },
    {
      type    = "EMAIL" 
      address = var.ops_email
    }
  ]
  
  threshold_amount = var.alert_threshold
  
  tags = {
    Customer    = var.customer_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
```

#### 3. Variables (`variables.tf`)
```hcl
variable "customer_name" {
  description = "Customer name for resource naming"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "finance_email" {
  description = "Finance team email for cost alerts"
  type        = string
}

variable "ops_email" {
  description = "Operations team email for cost alerts"
  type        = string
}

variable "alert_threshold" {
  description = "Cost anomaly alert threshold in USD"
  type        = number
  default     = 500
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}
```

#### 4. Customer Values (`terraform.tfvars`)
```hcl
customer_name    = "acme-corp"
aws_region      = "us-west-2"
finance_email   = "finance@acme-corp.com"
ops_email       = "devops@acme-corp.com"
alert_threshold = 1000
environment     = "production"
```

#### 5. Deploy
```bash
terraform plan
terraform apply
```

### Advanced Use Cases

#### Service-Specific Monitoring
```hcl
module "ec2_cost_monitoring" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/cost-anomaly-detection?ref=providers/aws/primitives/cost-anomaly-detection/v1.0.0"

  name = "${var.customer_name}-ec2-monitor"
  
  monitor_specification = {
    dimension_key = "SERVICE"
    match_options = ["EQUALS"]
    values        = ["EC2-Instance"]
  }
  
  subscribers = [
    {
      type    = "EMAIL"
      address = var.ops_email
    }
  ]
  
  threshold_amount = 200
  
  tags = {
    Customer = var.customer_name
    Service  = "EC2"
  }
}
```

#### Multi-Account Setup
```hcl
module "account_cost_monitoring" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/cost-anomaly-detection?ref=providers/aws/primitives/cost-anomaly-detection/v1.0.0"

  name = "${var.customer_name}-account-monitor"
  
  monitor_specification = {
    dimension_key = "LINKED_ACCOUNT"
    match_options = ["EQUALS"]
    values        = ["123456789012", "987654321098"]
  }
  
  subscribers = [
    {
      type    = "EMAIL"
      address = var.finance_email
    }
  ]
  
  threshold_amount = 2000
}
```

### Customer Benefits
- **5-minute deployment** with production-ready monitoring
- **Automatic cost alerts** on unusual spending patterns
- **Easy customization** of thresholds and recipients
- **Enterprise-grade reliability** through tested, security-hardened modules