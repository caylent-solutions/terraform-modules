.PHONY: build-terraform-file-collector configure detect-module-changes go-format go-install go-lint go-unit-test go-unit-test-coverage go-unit-test-coverage-json help install-tools module-validate rego-format rego-integration-test rego-lint rego-unit-test rego-unit-test-coverage rego-unit-test-coverage-json run-opa-policies test-all-non-tf-module-code test-all-terraform-modules tf-docs tf-docs-check tf-format tf-format-fix tf-lint tf-plan tf-security tf-test

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
	@go build -o ./bin/format ./scripts/go-format/main.go
	@./bin/format --config ./monorepo-config.json || { echo "Format check failed ❌"; rm -f ./bin/format; exit 1; }
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
	@go build -o ./bin/lint ./scripts/go-lint/main.go
	@./bin/lint --config ./monorepo-config.json || { echo "Lint check failed ❌"; rm -f ./bin/lint; exit 1; }
	@echo "Lint check complete"
	@rm -f ./bin/lint

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
	@go run ./scripts/module-validator/main.go --module-path $(MODULE_PATH) --module-type $(MODULE_TYPE) --config ./monorepo-config.json $(if $(VERBOSE),--verbose,)



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

# Run all non-Terraform module code tests and linting
test-all-non-tf-module-code:
	@echo "Running all Go and Rego tests and linting..."
	@echo "Running Go linting..."
	@make go-lint
	@echo "Running Go unit tests..."
	@make go-unit-test
	@echo "Running Rego linting..."
	@make rego-lint
	@echo "Running Rego unit tests..."
	@make rego-unit-test
	@echo "Running Rego integration tests..."
	@make rego-integration-test
	@echo "✅ All non-Terraform module code tests and linting passed"

# Run integration tests for OPA policies against compliant and non-compliant modules
rego-integration-test:
	@echo "Running OPA policy integration tests..."
	@echo "Testing compliant module (should pass all policies)..."
	make module-validate MODULE_PATH=skeletons/generic-skeleton MODULE_TYPE=skeleton | tee /tmp/compliant-test.log
	@echo "Checking validation results..."
	@grep -q "Failed:.*0 policy files" /tmp/compliant-test.log || (echo "❌ Compliant module has failing policies" && exit 1)
	@grep -q "Errors:.*0 policy files" /tmp/compliant-test.log || (echo "❌ Compliant module has policy errors" && exit 1)
	@grep -q "Passed:.*policy files" /tmp/compliant-test.log || (echo "❌ Compliant module has no passing policies" && exit 1)
	@echo "✅ Compliant module passed all policies"
	@echo ""
	@echo "Testing non-compliant module (should fail all policies)..."
	make module-validate MODULE_PATH=tests/opa/test-fixture/non-compliant-tf-module MODULE_TYPE=skeleton | tee /tmp/non-compliant-test.log || true
	@echo "Checking validation results..."
	@grep -q "Passed:.*0 policy files" /tmp/non-compliant-test.log || (echo "❌ Non-compliant module has passing policies" && exit 1)
	@grep -q "Errors:.*0 policy files" /tmp/non-compliant-test.log || (echo "❌ Non-compliant module has policy errors" && exit 1)
	@grep -q "Failed:.*policy files" /tmp/non-compliant-test.log || (echo "❌ Non-compliant module has no failing policies" && exit 1)
	@echo "✅ Non-compliant module failed policies as expected"
	@echo ""
	@echo "✅ All integration tests passed"

# Run tests for all Terraform modules in parallel
test-all-terraform-modules:
	@echo "Discovering and testing all Terraform modules..."
	@find generics/utilities providers/aws/collections providers/aws/primitives providers/aws/references providers/github/collections providers/github/primitives providers/github/references skeletons -mindepth 1 -maxdepth 1 -type d 2>/dev/null | grep -v ".terraform" | sort | xargs -I {} -P 4 sh -c '\
		echo "\n\033[1;36m=== Testing module: {} ===\033[0m"; \
		( \
			cd {} && \
			echo "\033[36m→ Running go-lint on tests\033[0m" && \
			make go-lint && \
			echo "\033[36m→ Running go-format on tests\033[0m" && \
			make go-format \
		) || exit 1; \
		echo "\033[36m→ Running tf-docs-check\033[0m"; \
		$(MAKE) tf-docs-check MODULE_PATH={} || exit 1; \
		echo "\033[36m→ Running tf-format\033[0m"; \
		$(MAKE) tf-format MODULE_PATH={} || exit 1; \
		echo "\033[36m→ Running tf-lint\033[0m"; \
		$(MAKE) tf-lint MODULE_PATH={} || exit 1; \
		echo "\033[36m→ Running module-validate\033[0m"; \
		$(MAKE) module-validate MODULE_PATH={} MODULE_TYPE=skeleton || exit 1; \
		echo "\033[36m→ Running tf-plan\033[0m"; \
		$(MAKE) tf-plan MODULE_PATH={} || exit 1; \
		echo "\033[36m→ Running tf-security\033[0m"; \
		$(MAKE) tf-security MODULE_PATH={} || exit 1; \
		echo "\033[36m→ Running tf-test\033[0m"; \
		$(MAKE) tf-test MODULE_PATH={} || exit 1; \
		echo "\033[1;32m✓ Module {} passed all tests\033[0m"; \
	'

# Run OPA policies against files in a target directory
# Usage: make run-opa-policies TARGET_PATH=path/to/target POLICY_DIRS=path/to/policies
run-opa-policies:
	@if [ -z "$(TARGET_PATH)" ]; then \
		echo "Error: TARGET_PATH is required"; \
		exit 1; \
	fi
	@if [ -z "$(POLICY_DIRS)" ]; then \
		echo "Error: POLICY_DIRS is required"; \
		exit 1; \
	fi
	@echo "Running OPA policies on files in $(TARGET_PATH)..."
	@go run ./scripts/run-opa-policies/main.go \
		--target-path $(TARGET_PATH) \
		--policy-dirs $(POLICY_DIRS)

# Check Rego files for linting issues
rego-lint:
	@echo "Checking Rego files for linting issues..."
	@find policies -name "*.rego" -type f | xargs -I{} opa check {} || { echo "Rego lint check failed ❌"; exit 1; }
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

# Run Terraform plan for all examples under MODULE_PATH
# Usage: make tf-plan MODULE_PATH=path/to/module
# In CI: Called with MODULE_PATH from detect-module-changes
# Requirements:
# - MODULE_PATH must exist
# - MODULE_PATH/examples must exist
# - Each example must contain terraform.tfvars
# - Plan is executed per example; all failures are fatal
tf-plan:
	@if [ -z "$(MODULE_PATH)" ]; then \
		echo "\033[1;31m❌ Error:\033[0m MODULE_PATH is required"; \
		exit 1; \
	fi
	@if [ ! -d "$(MODULE_PATH)" ]; then \
		echo "\033[1;31m❌ Error:\033[0m Module directory $(MODULE_PATH) does not exist"; \
		exit 1; \
	fi
	@if [ ! -d "$(MODULE_PATH)/examples" ]; then \
		echo "\033[1;31m❌ Error:\033[0m No examples directory found at $(MODULE_PATH)/examples"; \
		exit 1; \
	fi
	@found=0; \
	for tfvars in $(MODULE_PATH)/examples/*/terraform.tfvars; do \
		if [ -f "$$tfvars" ]; then \
			dir=$$(dirname "$$tfvars"); \
			name=$$(basename "$$dir"); \
			absdir=$$(cd "$$dir" && pwd); \
			echo ""; \
			echo "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"; \
			echo "\033[1;36m🔍 Running plan for:\033[0m \033[1;32m$$name\033[0m"; \
			echo "\033[1;90m📁 Path:\033[0m $$absdir"; \
			echo "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"; \
			terraform -chdir=$$dir init -backend=false > /dev/null || { echo "\033[1;31m❌ terraform init failed in $$dir\033[0m"; exit 1; }; \
			terraform -chdir=$$dir plan -var-file=terraform.tfvars -out=$$(realpath $$dir)/plan-$$name.tfplan || { echo "\033[1;31m❌ terraform plan failed in $$dir\033[0m"; exit 1; }; \
			found=1; \
		fi; \
	done; \
	if [ "$$found" -eq 0 ]; then \
		echo "\033[1;31m❌ Error:\033[0m No terraform.tfvars files found in any examples under $(MODULE_PATH)/examples/"; \
		exit 1; \
	fi


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