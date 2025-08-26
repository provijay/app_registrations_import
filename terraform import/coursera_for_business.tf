resource "azuread_application" "coursera_for_business" {
  display_name     = "Coursera for Business"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "http://adapplicationregistry.onmicrosoft.com/customappsso/primary",
    "https://shibboleth.coursera.org/sp",
  ]
}
