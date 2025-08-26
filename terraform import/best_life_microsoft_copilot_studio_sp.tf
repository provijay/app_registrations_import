resource "azuread_service_principal" "best_life_microsoft_copilot_studio" {
  client_id = azuread_application.best_life_microsoft_copilot_studio.client_id
}
