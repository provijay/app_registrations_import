resource "azuread_application" "biz_test_appproxy_iknow" {
  display_name     = "BIZ Test AppProxy iKnow"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://iknow-bizadaz.msappproxy.net",
  ]
}
