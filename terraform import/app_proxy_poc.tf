resource "azuread_application" "app_proxy_poc" {
  display_name     = "App Proxy PoC"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://appproxypoc-bizadaz.msappproxy.net/",
  ]
}
