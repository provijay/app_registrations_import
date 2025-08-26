resource "azuread_application" "sp_nsp_test_001" {
  display_name     = "sp-nsp-test-001"
  sign_in_audience = "AzureADMyOrg"
}
