resource "azuread_service_principal" "azurearcpoc" {
  client_id = azuread_application.azurearcpoc.client_id
}
