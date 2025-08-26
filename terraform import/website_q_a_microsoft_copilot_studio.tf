resource "azuread_application" "website_q_a_microsoft_copilot_studio" {
  display_name     = "Website Q&A (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
