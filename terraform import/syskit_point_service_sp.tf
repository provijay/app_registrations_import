resource "azuread_service_principal" "syskit_point_service" {
  client_id = azuread_application.syskit_point_service.client_id
}
