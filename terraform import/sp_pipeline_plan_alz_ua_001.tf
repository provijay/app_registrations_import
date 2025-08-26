resource "azuread_application" "sp_pipeline_plan_alz_ua_001" {
  display_name     = "sp-pipeline-plan-alz-ua-001"
  sign_in_audience = "AzureADMyOrg"
}
