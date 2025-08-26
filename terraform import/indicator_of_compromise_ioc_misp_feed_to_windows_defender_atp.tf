resource "azuread_application" "indicator_of_compromise_ioc_misp_feed_to_windows_defender_atp" {
  display_name     = "Indicator of Compromise (IOC) MISP Feed to Windows Defender ATP"
  sign_in_audience = "AzureADMultipleOrgs"
}
