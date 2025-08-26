resource "azuread_application" "azurearcpoc" {
  display_name     = "AzureArcPoc"
  sign_in_audience = "AzureADandPersonalMicrosoftAccount"
}
