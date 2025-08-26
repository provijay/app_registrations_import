resource "azuread_service_principal" "sp_pipeline_dev_lz_002" {
  client_id = azuread_application.sp_pipeline_dev_lz_002.client_id
}
