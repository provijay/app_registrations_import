resource "azuread_service_principal" "temp_logingestion_app" {
  client_id = azuread_application.temp_logingestion_app.client_id
}
