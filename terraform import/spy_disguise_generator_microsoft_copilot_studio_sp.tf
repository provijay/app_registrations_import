resource "azuread_service_principal" "spy_disguise_generator_microsoft_copilot_studio" {
  client_id = azuread_application.spy_disguise_generator_microsoft_copilot_studio.client_id
}
