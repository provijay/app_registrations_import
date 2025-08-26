resource "azuread_application" "github_proxima" {
  display_name     = "GitHub Proxima"
  sign_in_audience = "AzureADMyOrg"
}
