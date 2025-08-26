resource "azuread_service_principal" "appregmg_test" {
  client_id = azuread_application.appregmg_test.client_id
}
