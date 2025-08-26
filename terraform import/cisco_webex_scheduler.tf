resource "azuread_application" "cisco_webex_scheduler" {
  display_name     = "Cisco Webex Scheduler"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "https://bizadaz.onmicrosoft.com/acac2d12-4c37-43fe-9c67-584c444e0bde",
  ]
}
