resource "azuread_application" "commvault_teams_1" {
  display_name     = "CommVault_Teams_1"
  sign_in_audience = "AzureADMyOrg"
}
