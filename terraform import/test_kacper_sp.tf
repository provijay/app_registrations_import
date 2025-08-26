resource "azuread_service_principal" "test_kacper" {
  client_id = azuread_application.test_kacper.client_id
}
