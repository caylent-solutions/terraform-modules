.PHONY: detect-module-changes format install-tools lint module-validate pr-opa-policy-test tf-docs tf-docs-check tf-format tf-format-fix tf-lint tf-plan tf-security build-terraform-file-collector install configure tf-test

# Build and install terraform-file-collector binary
build-terraform-file-collector:
	@echo "Building terraform-file-collector binary..."
	@mkdir -p ./bin
	@go build -o ./bin/terraform-file-collector ./scripts/terraform-file-collector/main.go
	@chmod +x ./bin/terraform-file-collector
	@export PATH="$$PWD/bin:$$PATH"

# Configure environment with required tools
configure: install build-terraform-file-collector

# Detect if changes are in a module
# Used by CI pipeline to determine module path and type
# Outputs: IS_MODULE, MODULE_PATH, MODULE_TYPE
detect-module-changes:
	@go run ./scripts/detect-module-changes/main.go --config ./monorepo-config.json

format:
	@echo "Fixing code formatting and lint issues..."
	@mkdir -p ./bin
	@echo "Building format tool..."
	@go build -o ./bin/format ./scripts/format/main.go
	@./bin/format --ignore="bin"
	@rm -f ./bin/format

# Install Go dependencies
install:
	@echo "Installing Go dependencies..."
	@cd ./scripts/terraform-file-collector && go mod tidy

install-tools:
	@echo "Installing asdf and required development tools..."
	@mkdir -p ./bin
	@echo "Building install-tools..."
	@go build -o ./bin/install-tools ./scripts/install-tools/main.go
	@./bin/install-tools --asdf-version=v0.15.0
	@rm -f ./bin/install-tools

lint:
	@echo "Checking code for linting issues..."
	@mkdir -p ./bin
	@echo "Building lint tool..."
	@go build -o ./bin/lint ./scripts/lint/main.go
	@./bin/lint --ignore="bin" || echo "Lint check failed ❌"
	@rm -f ./bin/lint
	@echo "Lint check complete"

# Validate a specific module against its type-specific policies
# Usage: make module-validate MODULE_PATH=path/to/module MODULE_TYPE=module_type
# In CI: Called after detect-module-changes sets the MODULE_PATH and MODULE_TYPE variables
module-validate:
	@if [ -z "$(MODULE_PATH)" ]; then \
		echo "Error: MODULE_PATH is required"; \
		exit 1; \
	fi
	@if [ -z "$(MODULE_TYPE)" ]; then \
		echo "Error: MODULE_TYPE is required"; \
		exit 1; \
	fi
	@echo "Validating $(MODULE_TYPE) module at $(MODULE_PATH)..."
	@go run ./scripts/module-validator/main.go --module-path $(MODULE_PATH) --module-type $(MODULE_TYPE) --config ./monorepo-config.json

# Test PR against OPA policies
pr-opa-policy-test:
	go run ./scripts/pr-opa-policy-test/main.go --config ./monorepo-config.json --policy-dir ./policies/opa/global

# Generate Terraform documentation
# Usage: make tf-docs MODULE_PATH=path/to/module
# In CI: Called with MODULE_PATH from detect-module-changes
tf-docs:
	@if [ -z "$(MODULE_PATH)" ]; then \
		echo "Error: MODULE_PATH is required"; \
		exit 1; \
	fi
	@echo "Generating documentation for Terraform module at $(MODULE_PATH)..."
	@cd $(MODULE_PATH) && terraform-docs markdown . > TERRAFORM-DOCS.md

# Check if Terraform documentation is up-to-date
# Usage: make tf-docs-check MODULE_PATH=path/to/module
# In CI: Called with MODULE_PATH from detect-module-changes
tf-docs-check:
	@if [ -z "$(MODULE_PATH)" ]; then \
		echo "Error: MODULE_PATH is required"; \
		exit 1; \
	fi
	@echo "Checking if documentation is up-to-date for Terraform module at $(MODULE_PATH)..."
	@cd $(MODULE_PATH) && terraform-docs markdown . > TERRAFORM-DOCS.md.generated
	@cd $(MODULE_PATH) && diff TERRAFORM-DOCS.md TERRAFORM-DOCS.md.generated > /dev/null || (echo "ERROR: Documentation is out of date. Run 'make tf-docs MODULE_PATH=$(MODULE_PATH)' to update it." && exit 1)
	@cd $(MODULE_PATH) && rm TERRAFORM-DOCS.md.generated

# Terraform formatting check
# Usage: make tf-format MODULE_PATH=path/to/module
# In CI: Called with MODULE_PATH from detect-module-changes
tf-format:
	@if [ -z "$(MODULE_PATH)" ]; then \
		echo "Error: MODULE_PATH is required"; \
		exit 1; \
	fi
	@echo "Checking formatting of Terraform module at $(MODULE_PATH)..."
	@cd $(MODULE_PATH) && terraform fmt -check -recursive

# Fix Terraform formatting issues
# Usage: make tf-format-fix MODULE_PATH=path/to/module
tf-format-fix:
	@if [ -z "$(MODULE_PATH)" ]; then \
		echo "Error: MODULE_PATH is required"; \
		exit 1; \
	fi
	@echo "Fixing formatting of Terraform module at $(MODULE_PATH)..."
	@cd $(MODULE_PATH) && terraform fmt -recursive

# Terraform linting
# Usage: make tf-lint MODULE_PATH=path/to/module
# In CI: Called with MODULE_PATH from detect-module-changes
tf-lint:
	@if [ -z "$(MODULE_PATH)" ]; then \
		echo "Error: MODULE_PATH is required"; \
		exit 1; \
	fi
	@echo "Linting Terraform module at $(MODULE_PATH)..."
	@cd $(MODULE_PATH) && tflint

# Run Terraform plan
# Usage: make tf-plan MODULE_PATH=path/to/module
# In CI: Called with MODULE_PATH from detect-module-changes
tf-plan:
	@if [ -z "$(MODULE_PATH)" ]; then \
		echo "Error: MODULE_PATH is required"; \
		exit 1; \
	fi
	@echo "Running Terraform plan for module at $(MODULE_PATH)..."
	@cd $(MODULE_PATH) && terraform init -backend=false && terraform plan -out=plan.tfplan

# Check for security issues
# Usage: make tf-security MODULE_PATH=path/to/module
# In CI: Called with MODULE_PATH from detect-module-changes
tf-security:
	@if [ -z "$(MODULE_PATH)" ]; then \
		echo "Error: MODULE_PATH is required"; \
		exit 1; \
	fi
	@echo "Checking for security issues in Terraform module at $(MODULE_PATH)..."
	@cd $(MODULE_PATH) && tfsec .

# Run tests for a specific module
# Usage: make tf-test MODULE_PATH=path/to/module
# In CI: Called with MODULE_PATH from detect-module-changes
tf-test:
	@if [ -z "$(MODULE_PATH)" ]; then \
		echo "Error: MODULE_PATH is required"; \
		exit 1; \
	fi
	@echo "Running tests for Terraform module at $(MODULE_PATH)..."
	@if [ -f "$(MODULE_PATH)/test.config" ]; then \
		echo "Loading test configuration from $(MODULE_PATH)/test.config"; \
		. $(MODULE_PATH)/test.config; \
		cd $(MODULE_PATH) && TERRATEST_IDEMPOTENCY=$TERRATEST_IDEMPOTENCY make test; \
	else \
		echo "No test.config found, using default settings"; \
		cd $(MODULE_PATH) && make test; \
	fi