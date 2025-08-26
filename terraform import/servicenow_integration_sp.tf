resource "azuread_service_principal" "servicenow_integration" {
  client_id = azuread_application.servicenow_integration.client_id
}
