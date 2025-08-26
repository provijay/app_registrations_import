resource "azuread_application" "best_life_microsoft_copilot_studio" {
  display_name     = "Best Life (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
