resource "azuread_application" "access_token_claims_test" {
  display_name     = "Access Token Claims Test"
  sign_in_audience = "AzureADMyOrg"
}
