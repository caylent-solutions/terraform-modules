.PHONY: install test test-common clean clean-all go-lint go-format tf-docs tf-docs-check tf-format tf-format-fix tf-lint tf-plan tf-security tf-test test-all help generate-project

# Set GOARCH based on system architecture
define set_goarch
	ARCH=$$(uname -m); \
	if [ "$$ARCH" = "aarch64" ]; then \
		export GOARCH=arm64; \
	elif [ "$$ARCH" = "x86_64" ]; then \
		export GOARCH=amd64; \
	fi
endef

# Install dependencies
install:
	@echo "Installing dependencies..."
	@$(call set_goarch); \
	echo "Detected architecture: $$ARCH, setting GOARCH=$$GOARCH"; \
	go clean -cache -testcache -modcache; \
	go mod tidy; \
	go mod download; \
	go install github.com/caylent-solutions/terraform-terratest-framework/cmd/tftest
	@asdf reshim golang || true
	@echo "Dependencies installed successfully"

# Run all tests with clean cache and timeout
test:
	@echo "Cleaning Go test cache..."
	@$(call set_goarch); go clean -cache -testcache
	@echo "Cleaning up any existing Terraform state..."
	@find . -name "terraform.tfstate*" -delete 2>/dev/null || true
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@echo "Running tests with clean cache..."
	@echo "GO_TEST_TIMEOUT=$${GO_TEST_TIMEOUT:-not set}"
	@$(call set_goarch); tftest run --parallel-fixtures=false --parallel-tests=false GOFLAGS="-count=1"

# Run common tests with clean cache
test-common:
	@echo "Cleaning Go test cache..."
	@$(call set_goarch); go clean -cache -testcache
	@echo "Running common tests with clean cache..."
	@$(call set_goarch); TERRATEST_DISABLE_PARALLEL_TESTS=true go test ./tests/common -v -count=1

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	@find . -type d -name ".terraform" -exec rm -rf {} +
	@find . -name ".terraform.lock.hcl" -delete
	@find . -name "terraform.tfstate*" -delete
	@find . -name ".terraform.tfstate.lock.info" -delete

# Clean up everything including Go cache
clean-all: clean
	@echo "Cleaning Go cache..."
	@$(call set_goarch); go clean -cache -testcache
	@echo "All caches cleaned"

# Lint Go files in tests directory
go-lint:
	@echo "Linting Go files in tests directory..."
	@$(call set_goarch); REPO_ROOT=$$(git rev-parse --show-toplevel) && go run $$REPO_ROOT/scripts/go-lint/main.go --path tests

# Format Go files in tests directory
go-format:
	@echo "Formatting Go files in tests directory..."
	@$(call set_goarch); REPO_ROOT=$$(git rev-parse --show-toplevel) && go run $$REPO_ROOT/scripts/go-format/main.go --path tests

# Generate Terraform documentation
tf-docs:
	@echo "Generating documentation for Terraform module..."
	@terraform-docs markdown . > TERRAFORM-DOCS.md

# Check if Terraform documentation is up-to-date
tf-docs-check:
	@echo "Checking if documentation is up-to-date..."
	@terraform-docs markdown . > TERRAFORM-DOCS.md.generated
	@diff TERRAFORM-DOCS.md TERRAFORM-DOCS.md.generated > /dev/null || (echo "ERROR: Documentation is out of date. Run 'make tf-docs' to update it." && exit 1)
	@rm TERRAFORM-DOCS.md.generated

# Check Terraform formatting
tf-format:
	@echo "Checking Terraform formatting..."
	@terraform fmt -check -recursive

# Fix Terraform formatting issues
tf-format-fix:
	@echo "Fixing Terraform formatting..."
	@terraform fmt -recursive

# Lint Terraform files
tf-lint:
	@echo "Linting Terraform files..."
	@tflint

# Run Terraform plan for root and all example subfolders
tf-plan:
	@echo "\033[1;36m🚀 Running Terraform plan...\033[0m"
	@terraform init -backend=false > /dev/null || { echo "\033[1;31m❌ terraform init failed at root\033[0m"; exit 1; }

	@if [ -f "terraform.tfvars" ]; then \
		echo ""; \
		echo "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"; \
		echo "\033[1;36m🔍 Running plan for:\033[0m \033[1;32mroot\033[0m"; \
		echo "\033[1;90m📁 Path:\033[0m $$(pwd)"; \
		echo "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"; \
		terraform plan -var-file=terraform.tfvars -out=plan-root.tfplan || { echo "\033[1;31m❌ terraform plan failed at root\033[0m"; exit 1; }; \
	else \
		found=0; \
		for dir in examples/*/; do \
			tfvars="$$dir/terraform.tfvars"; \
			if [ -f "$$tfvars" ]; then \
				example=$$(basename "$$dir"); \
				absdir=$$(cd "$$dir" && pwd); \
				echo ""; \
				echo "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"; \
				echo "\033[1;36m🔍 Running plan for:\033[0m \033[1;32m$$example\033[0m"; \
				echo "\033[1;90m📁 Path:\033[0m $$absdir"; \
				echo "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"; \
				( \
					cd "$$dir" && \
					terraform init -backend=false > /dev/null && \
					terraform plan -var-file=terraform.tfvars -out="../../plan-$$example.tfplan" \
				) || { echo "\033[1;31m❌ terraform plan failed in $$dir\033[0m"; exit 1; }; \
				found=1; \
			fi; \
		done; \
		if [ "$$found" -eq 0 ]; then \
			echo "\033[1;31m❌ No terraform.tfvars found in root or examples – aborting\033[0m"; \
			exit 1; \
		fi; \
	fi

# Run security checks
tf-security:
	@echo "Checking for security issues..."
	@tfsec .

# Run Terraform tests with required config file
tf-test:
	@echo "Running Terraform tests..."
	@if [ -f "test.config" ]; then \
		echo "Loading test configuration from test.config"; \
		export $$(grep -v '^#' test.config | xargs); \
		echo "Loaded environment variables:"; \
		VAR_PATTERN=$$(grep -v '^#' test.config | cut -d= -f1 | paste -sd '|' -); \
		printenv | grep -E "^($$VAR_PATTERN)="; \
		make test; \
	else \
		echo "Error: test.config not found. Aborting."; \
		exit 1; \
	fi


# Run all tests (not fixing tasks)
test-all:
	@make clean-all
	@make go-lint
	@make go-format
	@make tf-docs-check
	@make tf-format
	@make tf-lint
	@make tf-plan
	@make tf-security
	@make tf-test

# Generate customer project structure
generate-project:
	@echo "🚀 Generating customer project structure..."
	@if [ -z "$(PROJECT_DIR)" ]; then \
		echo "❌ Error: PROJECT_DIR is required. Usage: make generate-project PROJECT_DIR=my-customer-project"; \
		exit 1; \
	fi
	@mkdir -p $(PROJECT_DIR)
	@echo "📁 Creating project directory: $(PROJECT_DIR)"
	@echo "# Customer AWS Infrastructure" > $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "# Global Account Cost Monitoring" >> $(PROJECT_DIR)/main.tf
	@echo "module \"global_cost_monitoring\" {" >> $(PROJECT_DIR)/main.tf
	@echo "  count = var.enable_global_monitoring ? 1 : 0" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  source = \"git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/cost-anomaly-detection?ref=providers/aws/primitives/cost-anomaly-detection/v1.0.0\"" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  name = \"\$${var.customer_name}-global-monitor\"" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  subscribers = [" >> $(PROJECT_DIR)/main.tf
	@echo "    {" >> $(PROJECT_DIR)/main.tf
	@echo "      type    = \"EMAIL\"" >> $(PROJECT_DIR)/main.tf
	@echo "      address = var.finance_email" >> $(PROJECT_DIR)/main.tf
	@echo "    }," >> $(PROJECT_DIR)/main.tf
	@echo "    {" >> $(PROJECT_DIR)/main.tf
	@echo "      type    = \"EMAIL\"" >> $(PROJECT_DIR)/main.tf
	@echo "      address = var.ops_email" >> $(PROJECT_DIR)/main.tf
	@echo "    }" >> $(PROJECT_DIR)/main.tf
	@echo "  ]" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  threshold_amount = var.global_alert_threshold" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  tags = {" >> $(PROJECT_DIR)/main.tf
	@echo "    Customer    = var.customer_name" >> $(PROJECT_DIR)/main.tf
	@echo "    Environment = var.environment" >> $(PROJECT_DIR)/main.tf
	@echo "    ManagedBy   = \"terraform\"" >> $(PROJECT_DIR)/main.tf
	@echo "    Monitor     = \"global\"" >> $(PROJECT_DIR)/main.tf
	@echo "  }" >> $(PROJECT_DIR)/main.tf
	@echo "}" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "# EC2 Service Cost Monitoring" >> $(PROJECT_DIR)/main.tf
	@echo "module \"ec2_cost_monitoring\" {" >> $(PROJECT_DIR)/main.tf
	@echo "  count = var.enable_ec2_monitoring ? 1 : 0" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  source = \"git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/cost-anomaly-detection?ref=providers/aws/primitives/cost-anomaly-detection/v1.0.0\"" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  name = \"\$${var.customer_name}-ec2-monitor\"" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  monitor_specification = {" >> $(PROJECT_DIR)/main.tf
	@echo "    dimension_key = \"SERVICE\"" >> $(PROJECT_DIR)/main.tf
	@echo "    match_options = [\"EQUALS\"]" >> $(PROJECT_DIR)/main.tf
	@echo "    values        = [\"EC2-Instance\"]" >> $(PROJECT_DIR)/main.tf
	@echo "  }" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  subscribers = [" >> $(PROJECT_DIR)/main.tf
	@echo "    {" >> $(PROJECT_DIR)/main.tf
	@echo "      type    = \"EMAIL\"" >> $(PROJECT_DIR)/main.tf
	@echo "      address = var.ops_email" >> $(PROJECT_DIR)/main.tf
	@echo "    }" >> $(PROJECT_DIR)/main.tf
	@echo "  ]" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  threshold_amount = var.ec2_alert_threshold" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  tags = {" >> $(PROJECT_DIR)/main.tf
	@echo "    Customer    = var.customer_name" >> $(PROJECT_DIR)/main.tf
	@echo "    Environment = var.environment" >> $(PROJECT_DIR)/main.tf
	@echo "    ManagedBy   = \"terraform\"" >> $(PROJECT_DIR)/main.tf
	@echo "    Monitor     = \"ec2\"" >> $(PROJECT_DIR)/main.tf
	@echo "  }" >> $(PROJECT_DIR)/main.tf
	@echo "}" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "# RDS Service Cost Monitoring" >> $(PROJECT_DIR)/main.tf
	@echo "module \"rds_cost_monitoring\" {" >> $(PROJECT_DIR)/main.tf
	@echo "  count = var.enable_rds_monitoring ? 1 : 0" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  source = \"git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/cost-anomaly-detection?ref=providers/aws/primitives/cost-anomaly-detection/v1.0.0\"" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  name = \"\$${var.customer_name}-rds-monitor\"" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  monitor_specification = {" >> $(PROJECT_DIR)/main.tf
	@echo "    dimension_key = \"SERVICE\"" >> $(PROJECT_DIR)/main.tf
	@echo "    match_options = [\"EQUALS\"]" >> $(PROJECT_DIR)/main.tf
	@echo "    values        = [\"RDS\"]" >> $(PROJECT_DIR)/main.tf
	@echo "  }" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  subscribers = [" >> $(PROJECT_DIR)/main.tf
	@echo "    {" >> $(PROJECT_DIR)/main.tf
	@echo "      type    = \"EMAIL\"" >> $(PROJECT_DIR)/main.tf
	@echo "      address = var.ops_email" >> $(PROJECT_DIR)/main.tf
	@echo "    }" >> $(PROJECT_DIR)/main.tf
	@echo "  ]" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  threshold_amount = var.rds_alert_threshold" >> $(PROJECT_DIR)/main.tf
	@echo "" >> $(PROJECT_DIR)/main.tf
	@echo "  tags = {" >> $(PROJECT_DIR)/main.tf
	@echo "    Customer    = var.customer_name" >> $(PROJECT_DIR)/main.tf
	@echo "    Environment = var.environment" >> $(PROJECT_DIR)/main.tf
	@echo "    ManagedBy   = \"terraform\"" >> $(PROJECT_DIR)/main.tf
	@echo "    Monitor     = \"rds\"" >> $(PROJECT_DIR)/main.tf
	@echo "  }" >> $(PROJECT_DIR)/main.tf
	@echo "}" >> $(PROJECT_DIR)/main.tf
	@echo "📝 Creating variables.tf..."
	@echo "variable \"customer_name\" {" > $(PROJECT_DIR)/variables.tf
	@echo "  description = \"Customer name for resource naming\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = string" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "" >> $(PROJECT_DIR)/variables.tf
	@echo "variable \"aws_region\" {" >> $(PROJECT_DIR)/variables.tf
	@echo "  description = \"AWS region\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = string" >> $(PROJECT_DIR)/variables.tf
	@echo "  default     = \"us-east-1\"" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "" >> $(PROJECT_DIR)/variables.tf
	@echo "# Cost Monitoring Toggles" >> $(PROJECT_DIR)/variables.tf
	@echo "variable \"enable_global_monitoring\" {" >> $(PROJECT_DIR)/variables.tf
	@echo "  description = \"Enable global account cost anomaly monitoring\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = bool" >> $(PROJECT_DIR)/variables.tf
	@echo "  default     = true" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "" >> $(PROJECT_DIR)/variables.tf
	@echo "variable \"enable_ec2_monitoring\" {" >> $(PROJECT_DIR)/variables.tf
	@echo "  description = \"Enable EC2 service cost anomaly monitoring\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = bool" >> $(PROJECT_DIR)/variables.tf
	@echo "  default     = true" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "" >> $(PROJECT_DIR)/variables.tf
	@echo "variable \"enable_rds_monitoring\" {" >> $(PROJECT_DIR)/variables.tf
	@echo "  description = \"Enable RDS service cost anomaly monitoring\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = bool" >> $(PROJECT_DIR)/variables.tf
	@echo "  default     = false" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "" >> $(PROJECT_DIR)/variables.tf
	@echo "variable \"finance_email\" {" >> $(PROJECT_DIR)/variables.tf
	@echo "  description = \"Finance team email for cost alerts\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = string" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "" >> $(PROJECT_DIR)/variables.tf
	@echo "variable \"ops_email\" {" >> $(PROJECT_DIR)/variables.tf
	@echo "  description = \"Operations team email for cost alerts\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = string" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "" >> $(PROJECT_DIR)/variables.tf
	@echo "variable \"security_email\" {" >> $(PROJECT_DIR)/variables.tf
	@echo "  description = \"Security team email for cost alerts\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = string" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "" >> $(PROJECT_DIR)/variables.tf
	@echo "variable \"global_alert_threshold\" {" >> $(PROJECT_DIR)/variables.tf
	@echo "  description = \"Global account cost anomaly alert threshold in USD\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = number" >> $(PROJECT_DIR)/variables.tf
	@echo "  default     = 1000" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "" >> $(PROJECT_DIR)/variables.tf
	@echo "variable \"ec2_alert_threshold\" {" >> $(PROJECT_DIR)/variables.tf
	@echo "  description = \"EC2 service cost anomaly alert threshold in USD\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = number" >> $(PROJECT_DIR)/variables.tf
	@echo "  default     = 200" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "" >> $(PROJECT_DIR)/variables.tf
	@echo "variable \"rds_alert_threshold\" {" >> $(PROJECT_DIR)/variables.tf
	@echo "  description = \"RDS service cost anomaly alert threshold in USD\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = number" >> $(PROJECT_DIR)/variables.tf
	@echo "  default     = 300" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "" >> $(PROJECT_DIR)/variables.tf
	@echo "variable \"environment\" {" >> $(PROJECT_DIR)/variables.tf
	@echo "  description = \"Environment name\"" >> $(PROJECT_DIR)/variables.tf
	@echo "  type        = string" >> $(PROJECT_DIR)/variables.tf
	@echo "  default     = \"production\"" >> $(PROJECT_DIR)/variables.tf
	@echo "}" >> $(PROJECT_DIR)/variables.tf
	@echo "📝 Creating versions.tf..."
	@echo "terraform {" > $(PROJECT_DIR)/versions.tf
	@echo "  required_version = \">= 1.12.1\"" >> $(PROJECT_DIR)/versions.tf
	@echo "" >> $(PROJECT_DIR)/versions.tf
	@echo "  required_providers {" >> $(PROJECT_DIR)/versions.tf
	@echo "    aws = {" >> $(PROJECT_DIR)/versions.tf
	@echo "      source  = \"hashicorp/aws\"" >> $(PROJECT_DIR)/versions.tf
	@echo "      version = \"~> 5.0\"" >> $(PROJECT_DIR)/versions.tf
	@echo "    }" >> $(PROJECT_DIR)/versions.tf
	@echo "  }" >> $(PROJECT_DIR)/versions.tf
	@echo "}" >> $(PROJECT_DIR)/versions.tf
	@echo "" >> $(PROJECT_DIR)/versions.tf
	@echo "provider \"aws\" {" >> $(PROJECT_DIR)/versions.tf
	@echo "  region = var.aws_region" >> $(PROJECT_DIR)/versions.tf
	@echo "}" >> $(PROJECT_DIR)/versions.tf
	@echo "📋 Creating terraform.tfvars template..."
	@echo "# Customer Configuration" > $(PROJECT_DIR)/terraform.tfvars
	@echo "customer_name = \"caylent-customer-name\"" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "aws_region   = \"us-east-1\"" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "environment  = \"production\"" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "# Cost Monitoring Configuration" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "enable_global_monitoring = true" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "enable_ec2_monitoring   = false" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "enable_rds_monitoring   = false" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "# Alert Thresholds (USD)" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "global_alert_threshold = 2000" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "ec2_alert_threshold   = 500" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "rds_alert_threshold   = 300" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "# Notification Emails" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "finance_email = \"finance@caylent-customer-fqdn\"" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "ops_email    = \"devops@caylent-customer-fqdn\"" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "security_email = \"security@caylent-customer-fqdn\"" >> $(PROJECT_DIR)/terraform.tfvars
	@echo "📄 Creating outputs.tf..."
	@echo "output \"global_monitor_arn\" {" > $(PROJECT_DIR)/outputs.tf
	@echo "  description = \"ARN of the global cost anomaly monitor\"" >> $(PROJECT_DIR)/outputs.tf
	@echo "  value       = var.enable_global_monitoring ? module.global_cost_monitoring[0].anomaly_monitor_arn : null" >> $(PROJECT_DIR)/outputs.tf
	@echo "}" >> $(PROJECT_DIR)/outputs.tf
	@echo "" >> $(PROJECT_DIR)/outputs.tf
	@echo "output \"ec2_monitor_arn\" {" >> $(PROJECT_DIR)/outputs.tf
	@echo "  description = \"ARN of the EC2 cost anomaly monitor\"" >> $(PROJECT_DIR)/outputs.tf
	@echo "  value       = var.enable_ec2_monitoring ? module.ec2_cost_monitoring[0].anomaly_monitor_arn : null" >> $(PROJECT_DIR)/outputs.tf
	@echo "}" >> $(PROJECT_DIR)/outputs.tf
	@echo "" >> $(PROJECT_DIR)/outputs.tf
	@echo "output \"rds_monitor_arn\" {" >> $(PROJECT_DIR)/outputs.tf
	@echo "  description = \"ARN of the RDS cost anomaly monitor\"" >> $(PROJECT_DIR)/outputs.tf
	@echo "  value       = var.enable_rds_monitoring ? module.rds_cost_monitoring[0].anomaly_monitor_arn : null" >> $(PROJECT_DIR)/outputs.tf
	@echo "}" >> $(PROJECT_DIR)/outputs.tf
	@echo "📖 Creating README.md..."
	@echo "# Cost Monitoring Setup" > $(PROJECT_DIR)/README.md
	@echo "" >> $(PROJECT_DIR)/README.md
	@echo "## Quick Start" >> $(PROJECT_DIR)/README.md
	@echo "1. Update \`terraform.tfvars\` with customer details" >> $(PROJECT_DIR)/README.md
	@echo "2. Run \`terraform init\`" >> $(PROJECT_DIR)/README.md
	@echo "3. Run \`terraform plan\`" >> $(PROJECT_DIR)/README.md
	@echo "4. Run \`terraform apply\`" >> $(PROJECT_DIR)/README.md
	@echo "" >> $(PROJECT_DIR)/README.md
	@echo "## Configuration" >> $(PROJECT_DIR)/README.md
	@echo "### Enable/Disable Monitors" >> $(PROJECT_DIR)/README.md
	@echo "- \`enable_global_monitoring\` - Account-wide cost monitoring" >> $(PROJECT_DIR)/README.md
	@echo "- \`enable_ec2_monitoring\` - EC2 service-specific monitoring" >> $(PROJECT_DIR)/README.md
	@echo "- \`enable_rds_monitoring\` - RDS service-specific monitoring" >> $(PROJECT_DIR)/README.md
	@echo "" >> $(PROJECT_DIR)/README.md
	@echo "### Alert Thresholds" >> $(PROJECT_DIR)/README.md
	@echo "- \`global_alert_threshold\` - Global account threshold (default: $2000)" >> $(PROJECT_DIR)/README.md
	@echo "- \`ec2_alert_threshold\` - EC2 service threshold (default: $500)" >> $(PROJECT_DIR)/README.md
	@echo "- \`rds_alert_threshold\` - RDS service threshold (default: $300)" >> $(PROJECT_DIR)/README.md
	@echo "✅ Project structure generated successfully in $(PROJECT_DIR)/"
	@echo "📋 Next steps:"
	@echo "   1. cd $(PROJECT_DIR)"
	@echo "   2. Edit terraform.tfvars with customer details"
	@echo "   3. terraform init && terraform plan"

# List all available make tasks with descriptions
help:
	@echo "Available make tasks:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "For tasks without descriptions:"
	@grep -E '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | grep -v "## " | sort | awk 'BEGIN {FS = ":"}; {printf "\033[36m%-30s\033[0m\n", $$1}'
	