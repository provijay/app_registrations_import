resource "azuread_application" "sp_azgovvis_dev_001" {
  display_name     = "sp-azgovvis-dev-001"
  sign_in_audience = "AzureADMyOrg"
}
