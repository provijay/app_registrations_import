resource "azuread_service_principal" "weather_guide_microsoft_copilot_studio" {
  client_id = azuread_application.weather_guide_microsoft_copilot_studio.client_id
}
