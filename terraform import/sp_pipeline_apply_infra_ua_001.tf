resource "azuread_application" "sp_pipeline_apply_infra_ua_001" {
  display_name     = "sp-pipeline-apply-infra-ua-001"
  sign_in_audience = "AzureADMyOrg"
}
