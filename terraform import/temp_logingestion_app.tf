resource "azuread_application" "temp_logingestion_app" {
  display_name     = "temp-logingestion-app"
  sign_in_audience = "AzureADMyOrg"
}
