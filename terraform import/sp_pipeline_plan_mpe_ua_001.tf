resource "azuread_application" "sp_pipeline_plan_mpe_ua_001" {
  display_name     = "sp-pipeline-plan-mpe-ua-001"
  sign_in_audience = "AzureADMyOrg"
}
