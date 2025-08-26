resource "azuread_application" "sp_spoketest_pipeline_dev_002" {
  display_name     = "sp-spoketest-pipeline-dev-002"
  sign_in_audience = "AzureADMyOrg"
}
