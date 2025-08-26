resource "azuread_service_principal" "sp_spoke_test_prod_001" {
  client_id = azuread_application.sp_spoke_test_prod_001.client_id
}
