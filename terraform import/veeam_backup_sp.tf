resource "azuread_service_principal" "veeam_backup" {
  client_id = azuread_application.veeam_backup.client_id
}
