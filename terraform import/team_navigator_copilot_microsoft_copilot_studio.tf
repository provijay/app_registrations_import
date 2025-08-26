resource "azuread_application" "team_navigator_copilot_microsoft_copilot_studio" {
  display_name     = "Team Navigator Copilot (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
