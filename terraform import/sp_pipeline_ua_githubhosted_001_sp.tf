resource "azuread_service_principal" "sp_pipeline_ua_githubhosted_001" {
  client_id = azuread_application.sp_pipeline_ua_githubhosted_001.client_id
}
