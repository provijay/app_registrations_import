resource "azuread_application" "spn_infra_tnet" {
  display_name     = "spn-infra-tnet"
  sign_in_audience = "AzureADMyOrg"
}
