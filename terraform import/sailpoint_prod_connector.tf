resource "azuread_application" "sailpoint_prod_connector" {
  display_name     = "SailPoint Prod Connector"
  sign_in_audience = "AzureADMultipleOrgs"
}
