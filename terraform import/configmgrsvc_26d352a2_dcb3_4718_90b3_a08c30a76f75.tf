resource "azuread_application" "configmgrsvc_26d352a2_dcb3_4718_90b3_a08c30a76f75" {
  display_name     = "ConfigMgrSvc_26d352a2-dcb3-4718-90b3-a08c30a76f75"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "api://e15bce1e-6f2d-44fd-93a9-f88717729d7f/af7834d6-5d42-44bc-9759-5b01b5e7174c",
  ]
}
