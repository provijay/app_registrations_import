resource "azuread_application" "galileo_openai_chatgpt" {
  display_name     = "Galileo OpenAI ChatGPT"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [
    "api://1fe340d1-e574-4eda-bd8b-d6bf8d57b206",
  ]
}
