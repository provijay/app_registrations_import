resource "azuread_application" "syskit_point_power_platform" {
  display_name     = "Syskit Point Power Platform"
  sign_in_audience = "AzureADMyOrg"
}
