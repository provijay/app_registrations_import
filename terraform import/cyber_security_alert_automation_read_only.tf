resource "azuread_application" "cyber_security_alert_automation_read_only" {
  display_name     = "Cyber Security Alert Automation Read Only"
  sign_in_audience = "AzureADMyOrg"
}
