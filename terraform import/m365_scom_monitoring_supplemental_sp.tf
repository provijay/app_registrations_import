resource "azuread_service_principal" "m365_scom_monitoring_supplemental" {
  client_id = azuread_application.m365_scom_monitoring_supplemental.client_id
}
