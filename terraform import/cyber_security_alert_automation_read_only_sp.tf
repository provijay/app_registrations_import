resource "azuread_service_principal" "cyber_security_alert_automation_read_only" {
  client_id = azuread_application.cyber_security_alert_automation_read_only.client_id
}
