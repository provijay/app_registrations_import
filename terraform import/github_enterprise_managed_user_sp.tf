resource "azuread_service_principal" "github_enterprise_managed_user" {
  client_id = azuread_application.github_enterprise_managed_user.client_id
}
