resource "azuread_service_principal" "sailpoint_test_connector" {
  client_id = azuread_application.sailpoint_test_connector.client_id
}
