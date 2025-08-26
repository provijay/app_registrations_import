resource "azuread_service_principal" "sp_azgovvis_dev_001" {
  client_id = azuread_application.sp_azgovvis_dev_001.client_id
}
