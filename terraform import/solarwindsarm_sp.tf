resource "azuread_service_principal" "solarwindsarm" {
  client_id = azuread_application.solarwindsarm.client_id
}
