resource "azuread_service_principal" "syskit_point_api" {
  client_id = azuread_application.syskit_point_api.client_id
}
