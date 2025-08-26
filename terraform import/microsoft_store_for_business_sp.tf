resource "azuread_service_principal" "microsoft_store_for_business" {
  client_id = azuread_application.microsoft_store_for_business.client_id
}
