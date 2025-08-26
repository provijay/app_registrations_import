resource "azuread_service_principal" "agent_250317t1_microsoft_copilot_studio" {
  client_id = azuread_application.agent_250317t1_microsoft_copilot_studio.client_id
}
