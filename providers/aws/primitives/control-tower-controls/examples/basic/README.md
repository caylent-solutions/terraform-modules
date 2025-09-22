# Basic Example

This directory contains a basic example of how to use the Control Tower controls module with minimal configuration.

## Usage

```hcl
locals {
  # Map of OUs to be used for target so users
  # don't have to remember or look up the OU IDs
  ou_map = {
    "test_ou1"   = "ou-qyyj-yjcjcdoj" # test_ou1
    "test_ou2"   = "ou-qyyj-r5eaoka2" # test_ou2
    "test_ou3"   = "ou-qyyj-w0yw6krm" # test_ou3
    "test_ou4"   = "ou-qyyj-cuxntp0t" # test_ou4
    "Level_2_ou" = "ou-qyyj-ads8zuff" # nested_ou_test1
    "Level_3_ou" = "ou-qyyj-rwmwd8n3" # nested_ou_level3
  }
}

module "controls" {
  source = "../../"

  map_ous_controls = {
    ########################################################################################################
    # Apply all strongly recommended controls to Sandbox OU                                                #
    # https://docs.aws.amazon.com/controltower/latest/controlreference/strongly-recommended-controls.html  #
    ########################################################################################################
    "sandbox_ou_controls" = {
      ou_ids                        = [local.ou_map["test_ou3"]]
      strongly_recommended_controls = true
    }
    ###########################################################################################################################
    # Apply all strongly recommended controls, elective controls, data residency controls and additional controls to lvl3_ou  #
    # https://docs.aws.amazon.com/controltower/latest/controlreference/strongly-recommended-controls.html                     #
    ###########################################################################################################################
    "Level_2_ou" = {
      ou_ids                        = [local.ou_map["Level_3_ou"]]
      strongly_recommended_controls = true
      elective_controls             = true
      data_residency_controls       = true
      individual_controls = [
        "AWS-GR_SUBNET_AUTO_ASSIGN_PUBLIC_IP_DISABLED"
      ]
    }

    ########################################################################################################
    # Apply elective controls, data residency controls and additional controls to lvl2_ou                  #
    # https://docs.aws.amazon.com/controltower/latest/controlreference/strongly-recommended-controls.html  #
    ########################################################################################################
    "Level_3_ou" = {
      ou_ids                  = [local.ou_map["Level_2_ou"]]
      elective_controls       = true
      data_residency_controls = true
      individual_controls = [
        "6rilu41n0gb9w6mxrkyewoer4",
        "AWS-GR_SUBNET_AUTO_ASSIGN_PUBLIC_IP_DISABLED"
      ]
    }
  }
}

}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_controls"></a> [controls](#module\_controls) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_map_ous_controls"></a> [map\_ous\_controls](#input\_map\_ous\_controls) | Mapping of OU groups to specific control configurations and OU targets | <pre>map(object({<br/><br/>    ou_ids = list(string)<br/><br/>    strongly_recommended_controls = optional(bool, false)<br/>    elective_controls             = optional(bool, false)<br/>    data_residency_controls       = optional(bool, false)<br/><br/>    # Controls identified by their NAME or CONTROL_CATALOG_OPAQUE_ID<br/>    # Example = "AWS-GR_CT_AUDIT_BUCKET_POLICY_CHANGES_PROHIBITED" or "dmvclaluiuvtsmivvw5t7an1x"<br/>    individual_controls = optional(list(string), [])<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
