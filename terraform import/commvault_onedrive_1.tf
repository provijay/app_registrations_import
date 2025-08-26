resource "azuread_application" "commvault_onedrive_1" {
  display_name     = "CommVault_OneDrive_1"
  sign_in_audience = "AzureADMyOrg"
}
