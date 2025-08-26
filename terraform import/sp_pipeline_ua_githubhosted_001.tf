resource "azuread_application" "sp_pipeline_ua_githubhosted_001" {
  display_name     = "sp-pipeline-ua-githubhosted-001"
  sign_in_audience = "AzureADMyOrg"
}
