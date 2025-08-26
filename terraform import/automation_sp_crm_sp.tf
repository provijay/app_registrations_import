resource "azuread_service_principal" "automation_sp_crm" {
  client_id = azuread_application.automation_sp_crm.client_id
}
