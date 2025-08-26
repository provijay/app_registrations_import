resource "azuread_service_principal" "sp_pipeline_ua_git_002" {
  client_id = azuread_application.sp_pipeline_ua_git_002.client_id
}
