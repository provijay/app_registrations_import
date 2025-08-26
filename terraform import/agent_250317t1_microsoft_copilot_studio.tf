resource "azuread_application" "agent_250317t1_microsoft_copilot_studio" {
  display_name     = "Agent 250317t1 (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
