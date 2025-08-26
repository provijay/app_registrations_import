resource "azuread_application" "sp_spoke_test_prod_001" {
  display_name     = "sp-spoke-test-prod-001"
  sign_in_audience = "AzureADMyOrg"
}
