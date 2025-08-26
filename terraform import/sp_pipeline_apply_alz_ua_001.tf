resource "azuread_application" "sp_pipeline_apply_alz_ua_001" {
  display_name     = "sp-pipeline-apply-alz-ua-001"
  sign_in_audience = "AzureADMyOrg"
}
