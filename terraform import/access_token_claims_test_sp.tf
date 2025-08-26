resource "azuread_service_principal" "access_token_claims_test" {
  client_id = azuread_application.access_token_claims_test.client_id
}
