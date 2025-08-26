resource "azuread_application" "bis_dke" {
  display_name     = "BIS DKE"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://dke.biz.org",
  ]
}
