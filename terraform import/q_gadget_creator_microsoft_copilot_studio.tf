resource "azuread_application" "q_gadget_creator_microsoft_copilot_studio" {
  display_name     = "Q Gadget Creator (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
