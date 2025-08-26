resource "azuread_service_principal" "syskit_point_client" {
  client_id = azuread_application.syskit_point_client.client_id
}
