resource "azuread_service_principal" "biz_test_appproxy_iknow" {
  client_id = azuread_application.biz_test_appproxy_iknow.client_id
}
