resource "azuread_service_principal" "coursera_for_business" {
  client_id = azuread_application.coursera_for_business.client_id
}
