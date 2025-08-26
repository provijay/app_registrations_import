resource "azuread_application" "syskit_point_api" {
  display_name     = "Syskit Point API"
  sign_in_audience = "AzureADMyOrg"
}
