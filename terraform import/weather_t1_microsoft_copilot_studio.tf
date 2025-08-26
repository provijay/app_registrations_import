resource "azuread_application" "weather_t1_microsoft_copilot_studio" {
  display_name     = "Weather t1 (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
