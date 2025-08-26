resource "azuread_application" "automation_sp_crm" {
  display_name     = "automation-sp-crm"
  sign_in_audience = "AzureADandPersonalMicrosoftAccount"
}
