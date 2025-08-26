resource "azuread_service_principal" "sailpoint_prod_connector" {
  client_id = azuread_application.sailpoint_prod_connector.client_id
}
