resource "azuread_service_principal" "biz_tnet_to_bisih_test" {
  client_id = azuread_application.biz_tnet_to_bisih_test.client_id
}
