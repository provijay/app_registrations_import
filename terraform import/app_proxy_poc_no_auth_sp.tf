resource "azuread_service_principal" "app_proxy_poc_no_auth" {
  client_id = azuread_application.app_proxy_poc_no_auth.client_id
}
