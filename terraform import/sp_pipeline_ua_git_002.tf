resource "azuread_application" "sp_pipeline_ua_git_002" {
  display_name     = "sp-pipeline-ua-git-002"
  sign_in_audience = "AzureADMyOrg"
}
