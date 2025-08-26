resource "azuread_application" "desktop_analytics" {
  display_name     = "Desktop Analytics"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://DesktopAnalyticsConfigMgrService",
  ]
}
