.PHONY: install test test-common clean clean-all go-lint go-format tf-docs tf-docs-check tf-format tf-format-fix tf-lint tf-plan tf-security tf-test test-all help

# Install dependencies
install:
	@echo "Installing dependencies..."
	@go clean -cache -testcache -modcache
	@go mod tidy
	@go mod download
	@go install github.com/caylent-solutions/terraform-terratest-framework/cmd/tftest
	@asdf reshim golang || true
	@echo "Dependencies installed successfully"

# Run all tests with clean cache
test:
	@echo "Cleaning Go test cache..."
	@go clean -cache -testcache
	@echo "Running all tests with clean cache..."
	@echo "TERRATEST_IDEMPOTENCY=${TERRATEST_IDEMPOTENCY:-true}"
	@TERRATEST_IDEMPOTENCY=${TERRATEST_IDEMPOTENCY:-true} GOFLAGS="-count=1" tftest run --parallel-fixtures=false --parallel-tests=false

# Run common tests with clean cache
test-common:
	@echo "Cleaning Go test cache..."
	@go clean -cache -testcache
	@echo "Running common tests with clean cache..."
	@. ~/.asdf/asdf.sh && TERRATEST_DISABLE_PARALLEL_TESTS=true go test ./tests/common -v -count=1

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
	@go clean -cache -testcache
	@echo "All caches cleaned"

# Lint Go files in tests directory
go-lint:
	@echo "Linting Go files in tests directory..."
	@go run ../../scripts/go-lint/main.go --path tests

# Format Go files in tests directory
go-format:
	@echo "Formatting Go files in tests directory..."
	@go run ../../scripts/go-format/main.go --path tests

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

# Run Terraform tests
tf-test:
	@echo "Running Terraform tests..."
	@if [ -f "test.config" ]; then \
		echo "Loading test configuration from test.config"; \
		export $(grep -v '^#' test.config | xargs); \
		TERRATEST_IDEMPOTENCY=${TERRATEST_IDEMPOTENCY:-true} make test; \
	else \
		echo "No test.config found, using default settings"; \
		TERRATEST_IDEMPOTENCY=true make test; \
	fi

# Run all tests (not fixing tasks)
test-all:
	@echo "Running all tests..."
	@make go-lint
	@make go-format
	@make tf-docs-check
	@make tf-format
	@make tf-lint
	@make tf-plan
	@make tf-security
	@make tf-test

# List all available make tasks with descriptions
help:
	@echo "Available make tasks:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "For tasks without descriptions:"
	@grep -E '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | grep -v "## " | sort | awk 'BEGIN {FS = ":"}; {printf "\033[36m%-30s\033[0m\n", $$1}'
	