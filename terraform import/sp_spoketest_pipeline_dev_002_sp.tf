resource "azuread_service_principal" "sp_spoketest_pipeline_dev_002" {
  client_id = azuread_application.sp_spoketest_pipeline_dev_002.client_id
}
