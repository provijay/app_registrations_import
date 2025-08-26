resource "azuread_application" "test_kacper" {
  display_name     = "Test-Kacper"
  sign_in_audience = "AzureADMyOrg"
}
