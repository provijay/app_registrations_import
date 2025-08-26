resource "azuread_application" "qradar" {
  display_name     = "QRadar"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://ibmsiem.bisinfo.org/console",
  ]
}
