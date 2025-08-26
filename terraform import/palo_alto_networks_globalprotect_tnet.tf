resource "azuread_application" "palo_alto_networks_globalprotect_tnet" {
  display_name     = "Palo Alto Networks - GlobalProtect TNET"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://connect.biz.org:443/SAML20/SP",
    "https://connect-gw.biz.org:443/SAML20/SP",
  ]
}
