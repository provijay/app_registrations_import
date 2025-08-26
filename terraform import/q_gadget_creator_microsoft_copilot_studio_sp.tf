resource "azuread_service_principal" "q_gadget_creator_microsoft_copilot_studio" {
  client_id = azuread_application.q_gadget_creator_microsoft_copilot_studio.client_id
}
