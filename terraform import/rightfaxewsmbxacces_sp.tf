resource "azuread_service_principal" "rightfaxewsmbxacces" {
  client_id = azuread_application.rightfaxewsmbxacces.client_id
}
