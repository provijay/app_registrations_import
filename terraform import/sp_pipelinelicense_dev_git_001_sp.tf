resource "azuread_service_principal" "sp_pipelinelicense_dev_git_001" {
  client_id = azuread_application.sp_pipelinelicense_dev_git_001.client_id
}
