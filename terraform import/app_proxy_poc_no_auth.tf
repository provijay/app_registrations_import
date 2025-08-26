resource "azuread_application" "app_proxy_poc_no_auth" {
  display_name     = "App Proxy PoC No-Auth"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://appproxypocnoauth-bizadaz.msappproxy.net/",
  ]
}
