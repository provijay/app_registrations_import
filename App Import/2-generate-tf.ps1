# 2-generate-tf.ps1
. .\0-prereqs-and-vars.ps1


# Generates TF files. The generator tries to map main fields: display_name, 
# sign_in_audience, web, spa, publicClient (native), 
# required_resource_access, api.app_roles, api.oauth2PermissionScopes. 
# It writes a mapping CSV linking TF resource name to objectId and appId.


# 2-generate-tf.ps1
# Generates .tf files for AzureAD App Registrations and Service Principals

# 2-generate-tf.ps1
# Generates Terraform .tf files for AzureAD Applications and Service Principals
# Input: appregs.json (exported using Azure CLI or AzureAD cmdlets)
# Output: apps.tf

# Read JSON file
$appRegs = Get-Content -Raw -Path "./appregs.json" | ConvertFrom-Json

# Initialize array for TF blocks
$tfBlocks = @()

foreach ($app in $appRegs) {
    $appId   = $app.appId
    $disp    = $app.displayName
    $san     = ($disp -replace '[^a-zA-Z0-9]', "_").ToLower()

    # Application block
    $tfApp  = @"
resource "azuread_application" "$san" {
  display_name     = "$disp"
  application_id   = "$appId"

  owners = []
  lifecycle {
    ignore_changes = [
      owners,
      required_resource_access,
      web,
      api,
      optional_claims
    ]
  }
}
"@

    # Service Principal block
    $tfSp = @"
resource "azuread_service_principal" "sp_$san" {
  application_id   = azuread_application.$san.application_id

  owners = []
  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}
"@

    $tfBlocks += $tfApp
    $tfBlocks += $tfSp
}

# Write to TF file
$tfBlocks -join "`n" | Out-File -FilePath "./apps.tf" -Encoding utf8

Write-Host "✅ apps.tf generated with $($appRegs.Count) applications"
