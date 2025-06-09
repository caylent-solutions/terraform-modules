# Terraform Module Tests

This directory contains tests for the Terraform module.

## Directory Structure

```
tests/
├── common/              # Tests that run on all examples
│   ├── module_test.go   # Common tests for all examples
│   └── input_validation_test.go # Tests for input validation
├── helpers/             # Helper functions for tests
│   └── helpers.go       # Common helper functions
├── basic/               # Tests for the basic example
│   └── module_test.go   # Tests specific to the basic example
└── advanced/            # Tests for the advanced example
    └── module_test.go   # Tests specific to the advanced example
```

## Test Categories

### Common Tests

The `common/` directory contains tests that run on all examples:
- Terraform validation
- Terraform formatting
- Required outputs
- File creation
- Various assertion types
- Input validation
- Benchmarking

### Example-Specific Tests

Each example has its own test directory with the same name:
- `basic/`: Tests for the basic example
- `advanced/`: Tests for the advanced example

### Helper Functions

The `helpers/` directory contains reusable helper functions for tests:
- File validation helpers
- Input validation helpers

## Input Validation Testing

The `input_validation_test.go` file demonstrates a robust approach to validating that inputs match outputs:

1. **Dynamic Input Reading**: Reads input values directly from terraform.tfvars files
2. **Output Comparison**: Compares these inputs with the actual outputs from Terraform
3. **Support for Complex Types**: Handles both simple string values and complex JSON structures

This approach is more reliable than trying to access input variables through the Terraform context, as it reads the actual values that would be used in a real deployment.

## Designing Effective Functional Tests

### Beyond Configuration Validation

While validating that inputs match outputs is a good starting point, truly effective tests should verify that the module **functions** as intended, not just that it provisions resources with the correct settings.

### Real-World Functional Testing

1. **Test the actual behavior**: 
   - For an S3 website with CloudFront, deploy a test HTML file and verify it's accessible via the CloudFront URL
   - For a database module, connect to the database and run queries
   - For a Lambda function, trigger the function and verify the response

2. **Test edge cases**:
   - What happens when resources are at capacity?
   - How does the module handle invalid inputs?
   - Does error handling work as expected?

3. **Test integration points**:
   - Verify that resources can communicate with each other
   - Test that permissions are correctly configured

### Example: Testing an S3 Website Module

```go
func TestS3WebsiteWorks(t *testing.T) {
    // Deploy the module
    ctx := testctx.RunSingleExample(t, "../../examples", "website", testctx.TestConfig{
        Name: "website-test",
    })
    
    // Get the CloudFront URL from the outputs
    cloudfrontURL := terraform.Output(t, ctx.Terraform, "cloudfront_domain_name")
    
    // Upload a test HTML file to the S3 bucket
    bucketName := terraform.Output(t, ctx.Terraform, "bucket_name")
    uploadTestFile(t, bucketName, "index.html", "<html><body>Test</body></html>")
    
    // Wait for CloudFront to propagate the changes
    time.Sleep(30 * time.Second)
    
    // Make an HTTP request to the CloudFront URL
    resp, err := http.Get("https://" + cloudfrontURL)
    assert.NoError(t, err, "HTTP request should succeed")
    defer resp.Body.Close()
    
    // Verify the response
    assert.Equal(t, 200, resp.StatusCode, "HTTP status code should be 200")
    body, err := io.ReadAll(resp.Body)
    assert.NoError(t, err, "Should be able to read response body")
    assert.Contains(t, string(body), "Test", "Response should contain the test content")
}
```

### Creating Test Fixtures

Complex modules often require elaborate test fixtures:

1. **Setup scripts**: Create scripts to generate test data or configure external services
2. **Dedicated environments**: Use dedicated QA and development AWS accounts for testing with real resources
3. **Test data generators**: Create realistic test data that exercises all module features
4. **Cleanup routines**: Ensure tests clean up after themselves, even if they fail

### Example: Test Fixture for a Database Module

```go
func setupDatabaseTestFixture(t *testing.T) {
    // Generate test data
    users := generateTestUsers(100)
    transactions := generateTestTransactions(1000)
    
    // Write test data to files that Terraform can use
    writeJSONToFile(t, "test-data/users.json", users)
    writeJSONToFile(t, "test-data/transactions.json", transactions)
    
    // Set up environment for the test
    os.Setenv("TF_VAR_test_data_path", "test-data")
}
```

### Continuous Testing Strategy

1. **Versioning discipline**: Use semantic versioning and test across version boundaries
2. **Regression tests**: When bugs are found, add tests that would have caught them
3. **Comprehensive testing**: Thorough functional testing enables safer use of modules with fuzzy version constraints
4. **Environment isolation**: Use separate AWS accounts for development, testing, and production

By designing tests that verify the actual functionality of your modules, you build confidence that they will work correctly in production and can be safely updated with minimal risk.

## Running Tests

Tests can be run using the provided Makefile commands from the root directory:

```bash
# Install dependencies (only needed once)
make install

# Run all tests
make test

# Run tests for a specific example
make test-basic
make test-advanced

# Run only common tests
make test-common

# Run a specific test
go test ./tests/common -run '^TestInputsMatchProvisioned$'

# Format all test files
make format
```

For more information on the `tftest` CLI tool, see the [CLI Usage Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/v0.4.2/docs/CLI_USAGE.md).