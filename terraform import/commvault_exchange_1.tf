resource "azuread_application" "commvault_exchange_1" {
  display_name     = "CommVault_Exchange_1"
  sign_in_audience = "AzureADMyOrg"
}
