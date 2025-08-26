resource "azuread_application" "weather_guide_microsoft_copilot_studio" {
  display_name     = "Weather Guide (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
