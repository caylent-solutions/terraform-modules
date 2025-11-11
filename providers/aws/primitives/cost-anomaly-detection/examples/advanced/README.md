# Advanced Example

This example demonstrates advanced usage of the generic skeleton module with complex JSON configuration.

## Features Demonstrated

- Using complex JSON configuration with nested objects and arrays
- Custom file permissions
- Output parsing and extraction
- Working with timestamps

## Usage

```hcl
module "example" {
  source          = "../../"
  output_content  = jsonencode(var.json_config)
  output_filename = var.output_filename
  file_permission = var.file_permission
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| json_config | JSON configuration for the output file | `any` | Complex object with message, enabled flag, retries, tags, and regions |
| output_filename | Path to the output file | `string` | `"default-output.json"` |
| file_permission | Permissions to set for the output file | `string` | `"0644"` |

## Outputs

| Name | Description |
|------|-------------|
| output_file_path | The path of the output file |
| output_content | The content written to the file |
| file_permission | The permissions of the output file |
| creation_timestamp | The timestamp when the file was created |
| json_data | The parsed JSON data |
| regions_list | List of regions from the JSON data |

## Example Configuration

This example uses the following configuration in `terraform.tfvars`:

```hcl
json_config = {
  message = "advanced"
  enabled = true
  retries = 5
  tags = {
    Name        = "test"
    Environment = "dev"
  }
  regions = ["us-west-2", "us-east-1"]
}
output_filename = "./advanced-output.json"
file_permission = "0600"
```

## Running the Example

```bash
# Initialize Terraform
terraform init

# Apply the configuration
terraform apply

# Verify the outputs
terraform output
```