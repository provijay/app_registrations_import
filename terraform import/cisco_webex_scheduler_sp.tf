resource "azuread_service_principal" "cisco_webex_scheduler" {
  client_id = azuread_application.cisco_webex_scheduler.client_id
}
