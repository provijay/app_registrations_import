resource "azuread_application" "quickaccess" {
  display_name     = "QuickAccess"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "api://4fce5bc5-33ce-4c4b-9151-5b539ba390b1",
  ]
}
