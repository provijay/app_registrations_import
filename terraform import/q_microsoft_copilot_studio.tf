resource "azuread_application" "q_microsoft_copilot_studio" {
  display_name     = "Q (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
