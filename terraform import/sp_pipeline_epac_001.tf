resource "azuread_application" "sp_pipeline_epac_001" {
  display_name     = "sp-pipeline-epac-001"
  sign_in_audience = "AzureADMyOrg"
}
