resource "azuread_service_principal" "quickaccess" {
  client_id = azuread_application.quickaccess.client_id
}
