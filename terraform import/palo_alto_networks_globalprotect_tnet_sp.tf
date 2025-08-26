resource "azuread_service_principal" "palo_alto_networks_globalprotect_tnet" {
  client_id = azuread_application.palo_alto_networks_globalprotect_tnet.client_id
}
