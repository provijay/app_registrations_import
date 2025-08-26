resource "azuread_application" "sp_pipeline_apply_mpe_ua_001" {
  display_name     = "sp-pipeline-apply-mpe-ua-001"
  sign_in_audience = "AzureADMyOrg"
}
