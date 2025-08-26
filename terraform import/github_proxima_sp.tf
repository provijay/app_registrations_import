resource "azuread_service_principal" "github_proxima" {
  client_id = azuread_application.github_proxima.client_id
}
