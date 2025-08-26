resource "azuread_service_principal" "jupyter_hub_med_prod" {
  client_id = azuread_application.jupyter_hub_med_prod.client_id
}
