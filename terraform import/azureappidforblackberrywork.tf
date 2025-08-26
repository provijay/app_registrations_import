resource "azuread_application" "azureappidforblackberrywork" {
  display_name     = "AzureAppIDforBlackBerryWork"
  sign_in_audience = "AzureADMyOrg"
}
