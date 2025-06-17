.PHONY: build-terraform-file-collector configure detect-module-changes go-format go-install go-lint go-unit-test go-unit-test-coverage go-unit-test-coverage-json help install-tools module-validate pr-opa-policy-test rego-format rego-lint rego-unit-test rego-unit-test-coverage rego-unit-test-coverage-json tf-docs tf-docs-check tf-format tf-format-fix tf-lint tf-plan tf-security tf-test

# Build and install terraform-file-collector binary
build-terraform-file-collector:
	@echo "Building terraform-file-collector binary..."
	@mkdir -p ./bin
	@go build -o ./bin/terraform-file-collector ./scripts/terraform-file-collector/main.go
	@chmod +x ./bin/terraform-file-collector
	@export PATH="$$PWD/bin:$$PATH"

# Configure environment with required tools
configure: go-install build-terraform-file-collector

# Detect if changes are in a module
# Used by CI pipeline to determine module path and type
# Outputs: IS_MODULE, MODULE_PATH, MODULE_TYPE
detect-module-changes:
	@go run ./scripts/detect-proposed-git-repo-changes/main.go --config ./monorepo-config.json

# Fix code formatting issues
go-format:
	@echo "Fixing code formatting and lint issues..."
	@mkdir -p ./bin
	@echo "Building format tool..."
	@go build -o ./bin/format ./scripts/format/main.go
	@./bin/format --ignore="bin"
	@rm -f ./bin/format

# Install Go dependencies
go-install:
	@echo "Installing Go dependencies..."
	@cd ./scripts/terraform-file-collector && go mod tidy

# Check code for linting issues
go-lint:
	@echo "Checking code for linting issues..."
	@mkdir -p ./bin
	@echo "Building lint tool..."
	@go build -o ./bin/lint ./scripts/lint/main.go
	@./bin/lint --ignore="bin" || echo "Lint check failed ❌"
	@rm -f ./bin/lint
	@echo "Lint check complete"

# Run all Go unit tests based on monorepo-config.json
go-unit-test:
	@echo "Running Go unit tests based on monorepo-config.json..."
	@go run scripts/go-unit-test/main.go --no-coverage monorepo-config.json

# Run all Go unit tests with coverage
go-unit-test-coverage:
	@mkdir -p tmp/coverage
	@go run scripts/go-unit-test/main.go --coverage-text monorepo-config.json

# Run all Go unit tests with coverage and output as JSON
go-unit-test-coverage-json:
	@mkdir -p tmp/coverage
	@go run scripts/go-unit-test/main.go --coverage-json monorepo-config.json

# List all available make tasks with descriptions
help:
	@echo "Available make tasks:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "For tasks without descriptions:"
	@grep -E '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | grep -v "## " | sort | awk 'BEGIN {FS = ":"}; {printf "\033[36m%-30s\033[0m\n", $$1}'

# Install ASDF and required development tools
install-tools:
	@echo "Installing asdf and required development tools..."
	@mkdir -p ./bin
	@echo "Building install-tools..."
	@go build -o ./bin/install-tools ./scripts/install-tools/main.go
	@./bin/install-tools --asdf-version=v0.15.0
	@rm -f ./bin/install-tools

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
# Usage: make pr-opa-policy-test FEATURE_BRANCH=feature-branch PRIMARY_BRANCH=main POLICY_DIRS=path/to/policies
pr-opa-policy-test:
	@if [ -z "$(FEATURE_BRANCH)" ]; then \
		echo "Error: FEATURE_BRANCH is required"; \
		exit 1; \
	fi
	@if [ -z "$(POLICY_DIRS)" ]; then \
		echo "Error: POLICY_DIRS is required"; \
		exit 1; \
	fi
	@echo "Testing PR from $(FEATURE_BRANCH) to ${PRIMARY_BRANCH:-main}..."
	go run ./scripts/pr-opa-policy-test/main.go \
		--config ./monorepo-config.json \
		--policy-dirs ${POLICY_DIRS} \
		--feature-branch $(FEATURE_BRANCH) \
		--primary-branch ${PRIMARY_BRANCH:-main}

# Run all Rego unit tests based on monorepo-config.json
rego-unit-test:
	@echo "Running Rego unit tests based on monorepo-config.json..."
	@go run scripts/rego-unit-test/main.go --no-coverage --data-path $(PWD) monorepo-config.json

# Run all Rego unit tests with coverage
rego-unit-test-coverage:
	@mkdir -p tmp/coverage
	@go run scripts/rego-unit-test/main.go --coverage-text --data-path $(PWD) monorepo-config.json

# Run all Rego unit tests with coverage and output as JSON
rego-unit-test-coverage-json:
	@mkdir -p tmp/coverage
	@go run scripts/rego-unit-test/main.go --coverage-json --data-path $(PWD) monorepo-config.json

# Check Rego files for linting issues
rego-lint:
	@echo "Checking Rego files for linting issues..."
	@find policies -name "*.rego" -type f | xargs -I{} opa check {} || echo "Rego lint check failed ❌"
	@echo "Rego lint check complete"

# Fix Rego formatting issues
rego-format:
	@echo "Fixing Rego formatting issues..."
	@find policies tests -name "*.rego" -type f -print0 | xargs -0 -I{} sh -c 'cp "{}" "{}.tmp" && opa fmt -w "{}" > /dev/null 2>&1 && if ! cmp -s "{}" "{}.tmp"; then echo "Fixed: {}"; fi && rm -f "{}.tmp"'

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