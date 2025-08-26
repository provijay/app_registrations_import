resource "azuread_service_principal" "q_microsoft_copilot_studio" {
  client_id = azuread_application.q_microsoft_copilot_studio.client_id
}
