resource "azuread_service_principal" "bis_infobot_microsoft_copilot_studio" {
  client_id = azuread_application.bis_infobot_microsoft_copilot_studio.client_id
}
