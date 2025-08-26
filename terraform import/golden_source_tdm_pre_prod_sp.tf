resource "azuread_service_principal" "golden_source_tdm_pre_prod" {
  client_id = azuread_application.golden_source_tdm_pre_prod.client_id
}
