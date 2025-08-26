resource "azuread_application" "sp_openai_poc_tst_001" {
  display_name     = "sp-openai-poc-tst-001"
  sign_in_audience = "AzureADMyOrg"
}
