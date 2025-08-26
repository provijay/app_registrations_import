resource "azuread_service_principal" "azureappidforblackberrywork" {
  client_id = azuread_application.azureappidforblackberrywork.client_id
}
