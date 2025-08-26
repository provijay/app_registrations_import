resource "azuread_service_principal" "commvault_exchange_1" {
  client_id = azuread_application.commvault_exchange_1.client_id
}
