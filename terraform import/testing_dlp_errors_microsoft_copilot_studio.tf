resource "azuread_application" "testing_dlp_errors_microsoft_copilot_studio" {
  display_name     = "Testing DLP errors (Microsoft Copilot Studio)"
  sign_in_audience = "AzureADMyOrg"
}
