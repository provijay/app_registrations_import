resource "azuread_application" "sailpoint_test_connector" {
  display_name     = "Sailpoint Test Connector"
  sign_in_audience = "AzureADMultipleOrgs"
}
