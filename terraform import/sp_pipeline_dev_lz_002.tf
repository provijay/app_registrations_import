resource "azuread_application" "sp_pipeline_dev_lz_002" {
  display_name     = "sp-pipeline-dev-lz-002"
  sign_in_audience = "AzureADandPersonalMicrosoftAccount"
}
