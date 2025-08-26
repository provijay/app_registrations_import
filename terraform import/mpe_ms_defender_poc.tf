resource "azuread_application" "mpe_ms_defender_poc" {
  display_name     = "MPE-MS-Defender-PoC"
  sign_in_audience = "AzureADMyOrg"
}
