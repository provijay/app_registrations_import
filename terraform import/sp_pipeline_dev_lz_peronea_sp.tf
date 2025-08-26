resource "azuread_service_principal" "sp_pipeline_dev_lz_peronea" {
  client_id = azuread_application.sp_pipeline_dev_lz_peronea.client_id
}
