resource "azuread_application" "sp_pipeline_apply_identity_ua_001" {
  display_name     = "sp-pipeline-apply-identity-ua-001"
  sign_in_audience = "AzureADMyOrg"
}
