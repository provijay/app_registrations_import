resource "azuread_application" "coe_command_center" {
  display_name     = "CoE Command Center"
  sign_in_audience = "AzureADMyOrg"
}
