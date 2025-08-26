resource "azuread_application" "loganalyticsingestion" {
  display_name     = "LogAnalyticsIngestion"
  sign_in_audience = "AzureADMyOrg"
}
