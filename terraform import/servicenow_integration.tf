resource "azuread_application" "servicenow_integration" {
  display_name     = "ServiceNow Integration"
  sign_in_audience = "AzureADMyOrg"
}
