resource "azuread_service_principal" "bcsalfresco2spotermstore_sync" {
  client_id = azuread_application.bcsalfresco2spotermstore_sync.client_id
}
