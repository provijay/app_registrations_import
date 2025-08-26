resource "azuread_application" "sp_pipelinelicense_dev_git_001" {
  display_name     = "sp-pipelinelicense-dev-git-001"
  sign_in_audience = "AzureADMyOrg"
}
