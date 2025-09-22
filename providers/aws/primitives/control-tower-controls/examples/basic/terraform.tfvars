map_ous_controls = {
  ########################################################################################################
  # Apply all strongly recommended controls to Sandbox OU                                                #
  # https://docs.aws.amazon.com/controltower/latest/controlreference/strongly-recommended-controls.html  #
  ########################################################################################################
  "sandbox_ou_controls" = {
    ou_ids                        = ["ou-qyyj-w0yw6krm"]
    strongly_recommended_controls = true
  }
  ###########################################################################################################################
  # Apply all strongly recommended controls, elective controls, data residency controls and additional controls to lvl3_ou  #
  # https://docs.aws.amazon.com/controltower/latest/controlreference/strongly-recommended-controls.html                     #
  ###########################################################################################################################
  "Level_2_ou" = {
    ou_ids                        = ["ou-qyyj-rwmwd8n3"]
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
    ou_ids                  = ["ou-qyyj-ads8zuff"]
    elective_controls       = true
    data_residency_controls = true
    individual_controls = [
      "6rilu41n0gb9w6mxrkyewoer4",
      "AWS-GR_SUBNET_AUTO_ASSIGN_PUBLIC_IP_DISABLED"
    ]
  }
}