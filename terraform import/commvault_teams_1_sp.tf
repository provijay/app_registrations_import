resource "azuread_service_principal" "commvault_teams_1" {
  client_id = azuread_application.commvault_teams_1.client_id
}
