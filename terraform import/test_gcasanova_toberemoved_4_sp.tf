resource "azuread_service_principal" "test_gcasanova_toberemoved_4" {
  client_id = azuread_application.test_gcasanova_toberemoved_4.client_id
}
