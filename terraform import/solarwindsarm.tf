resource "azuread_application" "solarwindsarm" {
  display_name     = "SolarWindsARM"
  sign_in_audience = "AzureADMyOrg"
}
