resource "azuread_application" "nist_ai_rmf_expert_microsoft_copilot_studio" {
  display_name     = "NIST AI RMF Expert (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMultipleOrgs"
}
