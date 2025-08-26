resource "azuread_service_principal" "commvault_onedrive_1" {
  client_id = azuread_application.commvault_onedrive_1.client_id
}
