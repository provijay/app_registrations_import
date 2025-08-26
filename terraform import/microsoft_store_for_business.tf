resource "azuread_application" "microsoft_store_for_business" {
  display_name     = "Microsoft Store for Business"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://ConfigMgrServiceMSfB",
  ]
}
