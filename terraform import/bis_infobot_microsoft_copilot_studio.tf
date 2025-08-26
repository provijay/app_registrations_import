resource "azuread_application" "bis_infobot_microsoft_copilot_studio" {
  display_name     = "BIS InfoBot (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
