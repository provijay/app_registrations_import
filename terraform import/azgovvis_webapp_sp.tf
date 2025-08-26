resource "azuread_service_principal" "azgovvis_webapp" {
  client_id = azuread_application.azgovvis_webapp.client_id
}
