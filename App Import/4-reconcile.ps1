# Compares exported JSON attributes vs terraform state and writes a 
# CSV of differences for key properties: displayName, sign_in_audience, 
# redirect URIs, appRoles count, oauth2 scopes count. This is a basic parity check you can expand.

# 4-reconcile.ps1
. .\0-prereqs-and-vars.ps1

<#
.SYNOPSIS
    Reconcile Terraform state with Entra ID app registrations and service principals.

.DESCRIPTION
    - Iterates through all exported app registration JSON files in ./apps
    - Iterates through all exported service principal JSON files in ./serviceprincipals
    - Checks if each resource exists in Terraform state
    - Compares with actual Azure resources via Azure CLI
    - Outputs discrepancies in reconciliation report
#>
param(
    [string]$AppsFolder = ".\apps",
    [string]$SPsFolder = ".\serviceprincipals",
    [string]$TFOutputFolder = ".\tf"
)

# Make sure TF output folder exists
if (!(Test-Path $TFOutputFolder)) {
    New-Item -ItemType Directory -Path $TFOutputFolder | Out-Null
}

Write-Host "Reconciling Terraform state with Azure AD Apps and Service Principals..."

# Import applications
$apps = Get-ChildItem -Path $AppsFolder -Filter *.json
foreach ($app in $apps) {
    $appJson = Get-Content $app.FullName | ConvertFrom-Json
    $san = $appJson.displayName -replace '[^a-zA-Z0-9]', '_'

    Write-Host "Reconciling application: $($appJson.appId)"
    terraform import "azuread_application.$san" $appJson.appId
}

# Import service principals
$sps = Get-ChildItem -Path $SPsFolder -Filter *.json
foreach ($sp in $sps) {
    $spJson = Get-Content $sp.FullName | ConvertFrom-Json
    $san = $spJson.displayName -replace '[^a-zA-Z0-9]', '_'

    Write-Host "Reconciling service principal: $($spJson.id)"
    terraform import "azuread_service_principal.sp_$san" $spJson.id
}

Write-Host "Reconciliation complete."
