resource "azuread_application" "sp_pipe_dev_lz_002" {
  display_name     = "sp-pipe-dev-lz-002"
  sign_in_audience = "AzureADMyOrg"
}
