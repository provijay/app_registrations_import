resource "azuread_application" "jupyter_hub_med_prod" {
  display_name     = "Jupyter HUB MED Prod"
  sign_in_audience = "AzureADMyOrg"
}
