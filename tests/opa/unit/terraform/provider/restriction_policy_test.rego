package terraform.module.providers.test

import data.terraform.module.providers as policy
import data.tests.opa.unit.helpers as helpers

# Test that Azure provider violates the policy
test_azure_provider_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "provider \"azurerm\" {\n  features {}\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	violations := policy.violation with input as test_input
	count(violations) == 1

	violations[{
		"policy": "provider_restriction_policy",
		"severity": "error",
		"message": "Disallowed cloud provider detected: azurerm",
		"details": "File modules/test-module/main.tf contains reference to azurerm provider. Only AWS is allowed among major cloud providers.",
		"resolution": "Remove the disallowed provider and use AWS resources instead",
	}]
}

# Test that Google provider violates the policy
test_google_provider_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "provider \"google\" {\n  project = \"my-project\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	violations := policy.violation with input as test_input
	count(violations) == 1

	violations[{
		"policy": "provider_restriction_policy",
		"severity": "error",
		"message": "Disallowed cloud provider detected: google",
		"details": "File modules/test-module/main.tf contains reference to google provider. Only AWS is allowed among major cloud providers.",
		"resolution": "Remove the disallowed provider and use AWS resources instead",
	}]
}

# Test that Google Beta provider violates the policy
test_google_beta_provider_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "provider \"google-beta\" {\n  project = \"my-project\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	violations := policy.violation with input as test_input
	count(violations) == 1

	violations[{
		"policy": "provider_restriction_policy",
		"severity": "error",
		"message": "Disallowed cloud provider detected: google-beta",
		"details": "File modules/test-module/main.tf contains reference to google-beta provider. Only AWS is allowed among major cloud providers.",
		"resolution": "Remove the disallowed provider and use AWS resources instead",
	}]
}

# Test that Azure AD provider violates the policy
test_azuread_provider_violation if {
	module_path := "modules/test-module"
	files := {"modules/test-module/main.tf": "provider \"azuread\" {\n  tenant_id = \"tenant-id\"\n}"}
	test_input := helpers.mock_terraform_module_input(module_path, files)

	violations := policy.violation with input as test_input
	count(violations) == 1

	violations[{
		"policy": "provider_restriction_policy",
		"severity": "error",
		"message": "Disallowed cloud provider detected: azuread",
		"details": "File modules/test-module/main.tf contains reference to azuread provider. Only AWS is allowed among major cloud providers.",
		"resolution": "Remove the disallowed provider and use AWS resources instead",
	}]
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
