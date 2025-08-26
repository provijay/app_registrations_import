resource "azuread_service_principal" "nist_ai_rmf_bot_microsoft_copilot_studio" {
  client_id = azuread_application.nist_ai_rmf_bot_microsoft_copilot_studio.client_id
}
