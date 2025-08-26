resource "azuread_service_principal" "mpe_ms_defender_poc" {
  client_id = azuread_application.mpe_ms_defender_poc.client_id
}
