resource "azuread_service_principal" "okta_biz" {
  client_id = azuread_application.okta_biz.client_id
}
