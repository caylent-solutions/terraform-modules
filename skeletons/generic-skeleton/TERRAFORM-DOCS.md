## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.3 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.13.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [time_static.creation_time](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_file_permission"></a> [file\_permission](#input\_file\_permission) | Permissions to set for the output file | `string` | `"0644"` | no |
| <a name="input_output_content"></a> [output\_content](#input\_output\_content) | Content to be written to the output file | `any` | n/a | yes |
| <a name="input_output_filename"></a> [output\_filename](#input\_output\_filename) | Path to the output file | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_creation_timestamp"></a> [creation\_timestamp](#output\_creation\_timestamp) | The timestamp when the file was created |
| <a name="output_file_permission"></a> [file\_permission](#output\_file\_permission) | The permissions of the output file |
| <a name="output_output_content"></a> [output\_content](#output\_output\_content) | The content written to the file |
| <a name="output_output_file_path"></a> [output\_file\_path](#output\_output\_file\_path) | The path of the output file |
