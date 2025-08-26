resource "azuread_service_principal" "app_proxy_poc" {
  client_id = azuread_application.app_proxy_poc.client_id
}
