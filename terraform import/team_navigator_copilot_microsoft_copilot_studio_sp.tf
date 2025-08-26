resource "azuread_service_principal" "team_navigator_copilot_microsoft_copilot_studio" {
  client_id = azuread_application.team_navigator_copilot_microsoft_copilot_studio.client_id
}
