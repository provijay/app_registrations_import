resource "azuread_service_principal" "a_007_design_assistant_microsoft_copilot_studio" {
  client_id = azuread_application.a_007_design_assistant_microsoft_copilot_studio.client_id
}
