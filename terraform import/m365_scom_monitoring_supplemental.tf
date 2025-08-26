resource "azuread_application" "m365_scom_monitoring_supplemental" {
  display_name     = "M365 SCOM Monitoring - Supplemental"
  sign_in_audience = "AzureADMyOrg"
}
