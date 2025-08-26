resource "azuread_service_principal" "loganalyticsingestion" {
  client_id = azuread_application.loganalyticsingestion.client_id
}
