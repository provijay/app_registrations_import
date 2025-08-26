resource "azuread_application" "alfresco_uat_tn" {
  display_name     = "alfresco-uat-tn"
  sign_in_audience = "AzureADMyOrg"
}
