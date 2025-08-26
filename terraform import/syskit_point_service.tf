resource "azuread_application" "syskit_point_service" {
  display_name     = "Syskit Point Service"
  sign_in_audience = "AzureADMyOrg"
}
