resource "azuread_service_principal" "weather_t1_microsoft_copilot_studio" {
  client_id = azuread_application.weather_t1_microsoft_copilot_studio.client_id
}
