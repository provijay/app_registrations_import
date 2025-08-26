resource "azuread_service_principal" "alfresco_uat_tn" {
  client_id = azuread_application.alfresco_uat_tn.client_id
}
