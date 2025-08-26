resource "azuread_service_principal" "sp_nsp_test_001" {
  client_id = azuread_application.sp_nsp_test_001.client_id
}
