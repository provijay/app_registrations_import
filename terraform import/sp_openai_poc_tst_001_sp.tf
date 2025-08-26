resource "azuread_service_principal" "sp_openai_poc_tst_001" {
  client_id = azuread_application.sp_openai_poc_tst_001.client_id
}
