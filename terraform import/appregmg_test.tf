resource "azuread_application" "appregmg_test" {
  display_name     = "appregmg-test"
  sign_in_audience = "AzureADMyOrg"
}
