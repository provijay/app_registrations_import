resource "azuread_application" "thehive_saml" {
  display_name     = "TheHive-SAML"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://web-sea-thehive-prod.apps.prod.ocp.bisinfo.org/api/sso/entraid",
  ]
}
