resource "azuread_service_principal" "azure_search_openai_demo" {
  client_id = azuread_application.azure_search_openai_demo.client_id
}
