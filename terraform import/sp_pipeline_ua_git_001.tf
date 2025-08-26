resource "azuread_application" "sp_pipeline_ua_git_001" {
  display_name     = "sp-pipeline-ua-git-001"
  sign_in_audience = "AzureADMyOrg"
}
