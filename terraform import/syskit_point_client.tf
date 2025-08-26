resource "azuread_application" "syskit_point_client" {
  display_name     = "Syskit Point Client"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "api://syskit-test.bisinfo.org/d3ccb9cf-01c8-40d1-bb3c-14e7c8424143",
  ]
}
