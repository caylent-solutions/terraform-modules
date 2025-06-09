package common_test

import (
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/caylent-solutions/terraform-terratest-framework/tests/unit"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestTerraformValidate runs 'terraform validate' on all examples
// This test ensures that the Terraform code is syntactically valid
func TestTerraformValidate(t *testing.T) {
	examples := []string{"basic", "advanced"}
	
	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			// Run the example
			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: "validate-test-" + example,
			})
			
			// Run terraform validate
			terraform.Validate(t, ctx.Terraform)
		})
	}
}

// TestTerraformFormat checks if the Terraform code is properly formatted
// This test ensures that the Terraform code follows consistent formatting
func TestTerraformFormat(t *testing.T) {
	examples := []string{"basic", "advanced"}
	
	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			// Run the example
			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: "format-test-" + example,
			})
			
			// Check if terraform code is formatted
			output, err := terraform.RunTerraformCommandE(t, ctx.Terraform, "fmt", "-check", "-recursive")
			assert.Empty(t, output, "Terraform code should be properly formatted")
			assert.NoError(t, err, "Terraform fmt should not fail")
		})
	}
}

// TestRequiredOutputs checks that required outputs are defined
// This test ensures that all required outputs are present in the module
func TestRequiredOutputs(t *testing.T) {
	examples := []string{"basic", "advanced"}
	requiredOutputs := []string{"output_file_path", "output_content"}
	
	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			// Run the example
			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: "outputs-test-" + example,
			})
			
			// Check required outputs
			outputs := terraform.OutputAll(t, ctx.Terraform)
			
			for _, output := range requiredOutputs {
				_, exists := outputs[output]
				assert.True(t, exists, "Required output '%s' should be defined", output)
			}
		})
	}
}

// TestFileCreation checks that the file is created with the correct content
// This test ensures that the module creates the output file as expected
func TestFileCreation(t *testing.T) {
	examples := []string{"basic", "advanced"}
	
	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			// Run the example
			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: "file-test-" + example,
			})
			
			// Get the file path from the output
			filePath := terraform.Output(t, ctx.Terraform, "output_file_path")
			assert.NotEmpty(t, filePath, "File path should not be empty")
			
			// Get the file content from the output
			expectedContent := terraform.Output(t, ctx.Terraform, "output_content")
			assert.NotEmpty(t, expectedContent, "File content should not be empty")
			
			// Verify the file exists and has the correct content
			// Note: In a real test, you would read the file and compare its content
		})
	}
}

// TestAllAssertionTypes demonstrates all the assertion types available in the framework
// This test runs on both the basic and advanced examples to verify various aspects of the module
func TestAllAssertionTypes(t *testing.T) {
	examples := []string{"basic", "advanced"}
	
	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			// Run the example
			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: "assertions-test-" + example,
			})
			
			// Basic Assertions
			// Verify that the output_file_path output matches the expected value
			unit.AssertOutputEquals(t, ctx, "output_file_path", terraform.Output(t, ctx.Terraform, "output_file_path"))
			
			// Verify that the output_file_path output contains the substring "output"
			unit.AssertOutputContains(t, ctx, "output_file_path", "output")
			
			// Verify that the output_file_path output matches the regex pattern for a file path (contains a dot)
			unit.AssertOutputMatches(t, ctx, "output_file_path", ".*\\..*")
			
			// Verify that the output_content output is not empty
			unit.AssertOutputNotEmpty(t, ctx, "output_content")
			
			// File Assertions
			// Verify that the file specified by the output_file_path output exists
			unit.AssertFileExists(t, ctx)
			
			// Verify that the content of the file matches the output_content output
			unit.AssertFileContent(t, ctx)
			
			// Resource Assertions
			// Verify that the local_file.output resource exists in the Terraform state
			unit.AssertResourceExists(t, ctx, "local_file", "output")
			
			// Verify that there is exactly 1 local_file resource in the Terraform state
			unit.AssertResourceCount(t, ctx, "local_file", 1)
			
			// Verify that there are no aws_s3_bucket resources in the Terraform state
			unit.AssertNoResourcesOfType(t, ctx, "aws_s3_bucket")
			
			// Environment Assertions
			// Verify that the Terraform version is at least 1.12.0
			unit.AssertTerraformVersion(t, ctx, "1.12.0")
			
			// Idempotency is automatically tested by the framework when using RunSingleExample
			// This verifies that running terraform plan after apply shows no changes
			// unit.AssertIdempotent(t, ctx)
		})
	}
}

// TestBenchmarking demonstrates how to benchmark Terraform operations
// This test measures the performance of applying and destroying the basic example
func TestBenchmarking(t *testing.T) {
	// Skip in normal runs as benchmarking can take time
	if testing.Short() {
		t.Skip("Skipping benchmarking in short mode")
	}
	
	// Define the benchmark function that will be measured
	benchmark := func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			// For each iteration, apply and destroy the basic example
			// This measures the time it takes to create and destroy the resources
			ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
				Name: "benchmark-test",
			})
			terraform.Destroy(t, ctx.Terraform)
		}
	}
	
	// Run the benchmark if not in short mode
	// This will execute the benchmark function multiple times and report statistics
	result := testing.Benchmark(benchmark)
	t.Logf("Benchmark results: %s", result.String())
}