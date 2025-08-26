resource "azuread_application" "giordapplication" {
  display_name     = "GiordApplication"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "http://fs.biz.org/adfs/services/trust",
  ]
}
