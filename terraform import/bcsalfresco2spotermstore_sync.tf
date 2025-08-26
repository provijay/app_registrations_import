resource "azuread_application" "bcsalfresco2spotermstore_sync" {
  display_name     = "BCSAlfresco2SPOTermStore_Sync"
  sign_in_audience = "AzureADMyOrg"
}
