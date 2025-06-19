module non-compliant-module

go 1.23.0

require (
	github.com/wrong-framework/test v1.0.0  // Wrong dependency, not terraform-terratest-framework
	github.com/stretchr/testify v1.10.0
)