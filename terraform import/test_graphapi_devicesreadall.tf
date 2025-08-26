resource "azuread_application" "test_graphapi_devicesreadall" {
  display_name     = "test-graphapi-devicesreadall"
  sign_in_audience = "AzureADMyOrg"
}
