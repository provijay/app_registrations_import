resource "azuread_service_principal" "syskit_point_power_platform" {
  client_id = azuread_application.syskit_point_power_platform.client_id
}
