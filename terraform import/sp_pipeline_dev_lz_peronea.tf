resource "azuread_application" "sp_pipeline_dev_lz_peronea" {
  display_name     = "sp-pipeline-dev-lz-peronea"
  sign_in_audience = "AzureADMyOrg"
}
