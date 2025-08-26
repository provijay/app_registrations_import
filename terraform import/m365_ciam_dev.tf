resource "azuread_application" "m365_ciam_dev" {
  display_name     = "M365 -CIAM-DEV"
  sign_in_audience = "AzureADMyOrg"
}
