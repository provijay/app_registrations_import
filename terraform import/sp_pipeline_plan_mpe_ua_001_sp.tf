resource "azuread_service_principal" "sp_pipeline_plan_mpe_ua_001" {
  client_id = azuread_application.sp_pipeline_plan_mpe_ua_001.client_id
}
