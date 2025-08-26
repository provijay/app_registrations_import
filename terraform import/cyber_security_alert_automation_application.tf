resource "azuread_application" "cyber_security_alert_automation_application" {
  display_name     = "Cyber Security Alert Automation Application"
  sign_in_audience = "AzureADMyOrg"
}
