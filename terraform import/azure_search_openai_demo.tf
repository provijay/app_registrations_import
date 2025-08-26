resource "azuread_application" "azure_search_openai_demo" {
  display_name     = "azure-search-openai-demo"
  sign_in_audience = "AzureADMyOrg"
}
