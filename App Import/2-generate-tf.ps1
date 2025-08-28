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
# Output directory for generated TF files
$outDir = ".\generated-tf"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

# Function to sanitize names for Terraform resource
function Sanitize-Name($name) {
    return ($name -replace '[^a-zA-Z0-9]', "_").ToLower()
}

# ----------------------------
# Process App Registrations
# ----------------------------
$appFolder = ".\apps"
$appFiles = Get-ChildItem -Path $appFolder -Filter "*.json"

foreach ($file in $appFiles) {
    $app = Get-Content -Raw $file.FullName | ConvertFrom-Json
    $san = Sanitize-Name $app.displayName
    $tfFile = Join-Path $outDir "$san-app.tf"

    $tfBlock = @"
resource "azuread_application" "$san" {
  display_name     = "$($app.displayName)"
  application_id   = "$($app.appId)"

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

    $tfBlock | Out-File -FilePath $tfFile -Encoding UTF8
    Write-Host "Generated TF for App: $($app.displayName)"
}

# ----------------------------
# Process Service Principals
# ----------------------------
$spFolder = ".\serviceprincipals"
$spFiles = Get-ChildItem -Path $spFolder -Filter "*.json"

foreach ($file in $spFiles) {
    $sp = Get-Content -Raw $file.FullName | ConvertFrom-Json
    $san = Sanitize-Name $sp.displayName
    $tfFile = Join-Path $outDir "$san-sp.tf"

    $tfBlock = @"
resource "azuread_service_principal" "sp_$san" {
  application_id   = "$($sp.appId)"

  owners = []

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}
"@

    $tfBlock | Out-File -FilePath $tfFile -Encoding UTF8
    Write-Host "Generated TF for SP: $($sp.displayName)"
}

Write-Host "✅ All TF files generated in $outDir"
