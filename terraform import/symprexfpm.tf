resource "azuread_application" "symprexfpm" {
  display_name     = "SymprexFPM"
  sign_in_audience = "AzureADMyOrg"
}
