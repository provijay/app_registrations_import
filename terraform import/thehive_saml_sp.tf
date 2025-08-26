resource "azuread_service_principal" "thehive_saml" {
  client_id = azuread_application.thehive_saml.client_id
}
