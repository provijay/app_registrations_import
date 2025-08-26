resource "azuread_service_principal" "cyber_security_compliance" {
  client_id = azuread_application.cyber_security_compliance.client_id
}
