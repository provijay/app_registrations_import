resource "azuread_application" "cyber_security_compliance" {
  display_name     = "Cyber Security Compliance"
  sign_in_audience = "AzureADMyOrg"
}
