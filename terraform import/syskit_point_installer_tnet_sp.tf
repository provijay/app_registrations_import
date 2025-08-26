resource "azuread_service_principal" "syskit_point_installer_tnet" {
  client_id = azuread_application.syskit_point_installer_tnet.client_id
}
