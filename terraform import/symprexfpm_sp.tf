resource "azuread_service_principal" "symprexfpm" {
  client_id = azuread_application.symprexfpm.client_id
}
