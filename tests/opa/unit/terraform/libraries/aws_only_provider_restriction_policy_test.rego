package terraform.libraries.aws_only_provider_restriction.test

import data.terraform.libraries.aws_only_provider_restriction as policy
import data.tests.opa.unit.helpers as helpers

# Test that Azure provider violates the policy
test_azure_provider_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "provider \"azurerm\" {\n  features {}\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that Google provider violates the policy
test_google_provider_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "provider \"google\" {\n  project = \"my-project\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that Google Beta provider violates the policy
test_google_beta_provider_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "provider \"google-beta\" {\n  project = \"my-project\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that Azure AD provider violates the policy
test_azuread_provider_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "provider \"azuread\" {\n  tenant_id = \"tenant-id\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) == 1
}

# Test that AWS provider passes the policy
test_aws_provider_no_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "provider \"aws\" {\n  region = \"us-west-2\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) == 0
}

# Test that other non-cloud providers pass the policy
test_other_providers_no_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "provider \"random\" {}\n\nprovider \"local\" {}\n\nprovider \"null\" {}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)
	violations := policy.violation with input as test_input
	count(violations) == 0
}
