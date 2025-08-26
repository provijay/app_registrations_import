resource "azuread_application" "github_enterprise_managed_user" {
  display_name     = "GitHub Enterprise Managed User"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://bis.ghe.com/enterprises/bis",
  ]
}
