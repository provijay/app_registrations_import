resource "azuread_service_principal" "giordapplication" {
  client_id = azuread_application.giordapplication.client_id
}
