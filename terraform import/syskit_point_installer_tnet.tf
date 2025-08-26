resource "azuread_application" "syskit_point_installer_tnet" {
  display_name     = "Syskit Point Installer TNET"
  sign_in_audience = "AzureADMyOrg"
}
