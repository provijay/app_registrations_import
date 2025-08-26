resource "azuread_service_principal" "spn_infra_tnet" {
  client_id = azuread_application.spn_infra_tnet.client_id
}
