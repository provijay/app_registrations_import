resource "azuread_service_principal" "galileo_openai_chatgpt" {
  client_id = azuread_application.galileo_openai_chatgpt.client_id
}
