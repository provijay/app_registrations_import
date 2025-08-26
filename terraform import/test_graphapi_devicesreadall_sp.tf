resource "azuread_service_principal" "test_graphapi_devicesreadall" {
  client_id = azuread_application.test_graphapi_devicesreadall.client_id
}
