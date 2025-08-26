resource "azuread_application" "spy_disguise_generator_microsoft_copilot_studio" {
  display_name     = "Spy Disguise Generator (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
