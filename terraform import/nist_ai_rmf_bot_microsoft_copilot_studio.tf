resource "azuread_application" "nist_ai_rmf_bot_microsoft_copilot_studio" {
  display_name     = "NIST AI RMF Bot (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
