resource "azuread_application" "website_q_a_1_microsoft_copilot_studio" {
  display_name     = "Website Q&A 1 (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
