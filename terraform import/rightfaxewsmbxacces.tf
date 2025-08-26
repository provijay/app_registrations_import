resource "azuread_application" "rightfaxewsmbxacces" {
  display_name     = "RightFaxEWSMBXAcces"
  sign_in_audience = "AzureADMyOrg"
}
