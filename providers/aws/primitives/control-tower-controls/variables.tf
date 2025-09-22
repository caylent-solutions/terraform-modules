variable "map_ous_controls" {
  description = "Mapping of OU groups to specific control configurations and OU targets"
  type = map(object({

    ou_ids = list(string)

    strongly_recommended_controls = optional(bool, false)
    elective_controls             = optional(bool, false)
    data_residency_controls       = optional(bool, false)

    # Controls identified by their NAME or CONTROL_CATALOG_OPAQUE_ID
    # Example = "AWS-GR_CT_AUDIT_BUCKET_POLICY_CHANGES_PROHIBITED" or "dmvclaluiuvtsmivvw5t7an1x"
    individual_controls = optional(list(string), [])
  }))
}
