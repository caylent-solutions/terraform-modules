## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_chatbot"></a> [chatbot](#module\_chatbot) | ../../ | n/a |
| <a name="module_chatbot_test_sns"></a> [chatbot\_test\_sns](#module\_chatbot\_test\_sns) | terraform-aws-modules/sns/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chatbot_name"></a> [chatbot\_name](#input\_chatbot\_name) | Used to uniquely identify IAM resources. | `string` | n/a | yes |
| <a name="input_create_default_iam_role"></a> [create\_default\_iam\_role](#input\_create\_default\_iam\_role) | If true, a default IAM role and policy will be created.<br/>If false, the user must provide an existing IAM role<br/>with the necessary permissions for every channel configuration.<br/>If defined, "iam\_role\_arn" is used instead of the default role. | `bool` | `true` | no |
| <a name="input_slack_channel_configurations"></a> [slack\_channel\_configurations](#input\_slack\_channel\_configurations) | Map of Slack channel configurations | <pre>map(object({<br/>    configuration_name = string<br/>    iam_role_arn       = optional(string) # User-defined role that AWS Chatbot assumes. This is not the service-linked role<br/>    slack_channel_id   = string           # For example, C07EZ1ABC23<br/>    slack_team_id      = string           # This is the ID you get when you authorize the Slack workspace with AWS Chatbot in UI. See README.md for more details.<br/><br/>    # Optionals<br/>    guardrail_policy_arns       = optional(list(string)) # The AWS managed AdministratorAccess policy is applied by default if this is not set<br/>    logging_level               = optional(string)       # ERROR, INFO, or NONE<br/>    sns_topic_arns              = optional(list(string))<br/>    user_authorization_required = optional(bool)<br/>  }))</pre> | n/a | yes |
| <a name="input_sns_chatbot_name"></a> [sns\_chatbot\_name](#input\_sns\_chatbot\_name) | Name of the SNS topic used by AWS Chatbot | `string` | n/a | yes |
| <a name="input_teams_channel_configurations"></a> [teams\_channel\_configurations](#input\_teams\_channel\_configurations) | Map of Teams channel configurations | <pre>map(object({<br/>    configuration_name = string<br/>    iam_role_arn       = optional(string) # User-defined role that AWS Chatbot assumes. This is not the service-linked role<br/>    channel_id         = string           # For example, "19%3AmClUolIkLiqQtIBNQCh3J4aQqEJ9jOHTU93AYfHDA5c1%40thread.tacv2"<br/>    team_id            = string           # For example, "680e968a-3e01-4119-abbf-1a4458f9ea22"<br/>    tenant_id          = string           # For example, "7346df00-af54-41f4-b792-a4f465b5b568."<br/><br/>    # Optionals<br/>    guardrail_policy_arns       = optional(list(string)) # The AWS managed AdministratorAccess policy is applied by default if this is not set<br/>    logging_level               = optional(string)       # ERROR, INFO, or NONE<br/>    sns_topic_arns              = optional(list(string))<br/>    user_authorization_required = optional(bool)<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
