resource "azuread_service_principal" "coe_command_center" {
  client_id = azuread_application.coe_command_center.client_id
}
