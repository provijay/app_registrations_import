resource "azuread_application" "test_gcas" {
  display_name     = "test-gcas"
  sign_in_audience = "AzureADMyOrg"
}
