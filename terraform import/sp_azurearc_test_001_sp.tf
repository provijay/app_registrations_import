resource "azuread_service_principal" "sp_azurearc_test_001" {
  client_id = azuread_application.sp_azurearc_test_001.client_id
}
