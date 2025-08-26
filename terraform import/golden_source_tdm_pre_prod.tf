resource "azuread_application" "golden_source_tdm_pre_prod" {
  display_name     = "Golden Source (TDM) Pre-Prod"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://lbnds1513.bisinfo.org:9343/auth/realms/tdmpreprod",
  ]
}
