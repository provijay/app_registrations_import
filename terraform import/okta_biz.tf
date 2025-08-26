resource "azuread_application" "okta_biz" {
  display_name     = "Okta BIZ"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://www.okta.com/saml2/service-provider/spxifwyqrvzgdrfoqaod",
  ]
}
