resource "azuread_application" "azgovvis_webapp" {
  display_name     = "AzGovVis-webApp"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "api://3b16cc3d-cc51-4965-8719-95225a2b8df0",
  ]
}
