resource "azuread_service_principal" "testing_dlp_errors_microsoft_copilot_studio" {
  client_id = azuread_application.testing_dlp_errors_microsoft_copilot_studio.client_id
}
