resource "azuread_service_principal" "m365_ciam_dev" {
  client_id = azuread_application.m365_ciam_dev.client_id
}
