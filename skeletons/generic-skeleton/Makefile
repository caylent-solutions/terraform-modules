.PHONY: install test format clean

# Install dependencies
install:
	@echo "Installing dependencies..."
	@go mod tidy
	@go install github.com/caylent-solutions/terraform-terratest-framework/cmd/tftest@$$(grep terraform-terratest-framework go.mod | awk '{print $$2}')
	@asdf reshim golang || true
	@echo "Dependencies installed successfully"

# Run all tests
test:
	@echo "Running all tests..."
	@tftest run

# Run tests for a specific example
test-basic:
	@echo "Running basic example tests..."
	@tftest run --example-path basic

test-advanced:
	@echo "Running advanced example tests..."
	@tftest run --example-path advanced

# Run common tests
test-common:
	@echo "Running common tests..."
	@. ~/.asdf/asdf.sh && go test ./tests/common -v

# Format all test files
format:
	@echo "Formatting test files..."
	@tftest format --all

# Clean up temporary files
clean:
	@echo "Cleaning up..."
	@rm -rf .terraform
	@find . -name ".terraform.lock.hcl" -delete
	@find . -name "terraform.tfstate*" -delete
	@find . -name ".terraform.tfstate.lock.info" -delete