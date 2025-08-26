resource "azuread_service_principal" "cyber_security_alert_automation_application" {
  client_id = azuread_application.cyber_security_alert_automation_application.client_id
}
