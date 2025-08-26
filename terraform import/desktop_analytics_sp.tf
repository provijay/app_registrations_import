resource "azuread_service_principal" "desktop_analytics" {
  client_id = azuread_application.desktop_analytics.client_id
}
