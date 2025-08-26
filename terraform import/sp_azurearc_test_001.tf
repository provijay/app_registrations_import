resource "azuread_application" "sp_azurearc_test_001" {
  display_name     = "sp-azurearc-test-001"
  sign_in_audience = "AzureADandPersonalMicrosoftAccount"
}
