resource "azuread_service_principal" "vr007250404t1_microsoft_copilot_studio" {
  client_id = azuread_application.vr007250404t1_microsoft_copilot_studio.client_id
}
