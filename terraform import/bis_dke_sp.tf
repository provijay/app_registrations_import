resource "azuread_service_principal" "bis_dke" {
  client_id = azuread_application.bis_dke.client_id
}
