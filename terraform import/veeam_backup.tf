resource "azuread_application" "veeam_backup" {
  display_name     = "Veeam Backup"
  sign_in_audience = "AzureADMyOrg"
}
