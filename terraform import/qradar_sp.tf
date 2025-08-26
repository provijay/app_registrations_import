resource "azuread_service_principal" "qradar" {
  client_id = azuread_application.qradar.client_id
}
