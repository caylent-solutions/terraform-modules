## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_example"></a> [example](#module\_example) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_file_permission"></a> [file\_permission](#input\_file\_permission) | Permissions to set for the output file | `string` | `"0644"` | no |
| <a name="input_json_config"></a> [json\_config](#input\_json\_config) | JSON configuration for the output file | `any` | <pre>{<br/>  "enabled": false,<br/>  "message": "default",<br/>  "regions": [<br/>    "us-east-1"<br/>  ],<br/>  "retries": 3,<br/>  "tags": {<br/>    "Environment": "test",<br/>    "Name": "default"<br/>  }<br/>}</pre> | no |
| <a name="input_output_filename"></a> [output\_filename](#input\_output\_filename) | Path to the output file | `string` | `"default-output.json"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_creation_timestamp"></a> [creation\_timestamp](#output\_creation\_timestamp) | The timestamp when the file was created |
| <a name="output_file_permission"></a> [file\_permission](#output\_file\_permission) | The permissions of the output file |
| <a name="output_json_data"></a> [json\_data](#output\_json\_data) | The parsed JSON data |
| <a name="output_output_content"></a> [output\_content](#output\_output\_content) | The content written to the file |
| <a name="output_output_file_path"></a> [output\_file\_path](#output\_output\_file\_path) | The path of the output file |
| <a name="output_regions_list"></a> [regions\_list](#output\_regions\_list) | List of regions from the JSON data |
