resource "azuread_service_principal" "test_gcas" {
  client_id = azuread_application.test_gcas.client_id
}
