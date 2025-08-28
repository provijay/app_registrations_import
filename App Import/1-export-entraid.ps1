# 1-export-entraid.ps1
. .\0-prereqs-and-vars.ps1
# Exports the full set of application and service principal properties to JSON and owners to CSV.

<#
.SYNOPSIS
Export all Entra App Registrations & Service Principals via Azure CLI into JSON files
to be used for Terraform reverse engineering.

.REQUIREMENTS
- Azure CLI installed
- Logged in: az login
- Proper permissions (Directory Reader / Application.Read.All)
#>

# Output directories
$appOutputDir = "./exports/apps"
$spnOutputDir = "./exports/servicePrincipals"

# Ensure directories exist
New-Item -ItemType Directory -Force -Path $appOutputDir | Out-Null
New-Item -ItemType Directory -Force -Path $spnOutputDir | Out-Null

Write-Host "Fetching all App Registrations from Entra (Azure AD)..."

# Get all applications (App Registrations)
$apps = az ad app list --all | ConvertFrom-Json

foreach ($app in $apps) {
    $appId = $app.appId
    $fileName = "$appOutputDir/$($app.displayName)-$appId.json"

    # Export app details
    $app | ConvertTo-Json -Depth 10 | Out-File -FilePath $fileName -Encoding UTF8

    Write-Host "Exported App Registration: $($app.displayName)"
}

Write-Host "Fetching all Service Principals from Entra (Azure AD)..."

# Get all service principals
$spns = az ad sp list --all | ConvertFrom-Json

foreach ($spn in $spns) {
    $spnId = $spn.appId
    $fileName = "$spnOutputDir/$($spn.displayName)-$spnId.json"

    # Export service principal details
    $spn | ConvertTo-Json -Depth 10 | Out-File -FilePath $fileName -Encoding UTF8

    Write-Host "Exported Service Principal: $($spn.displayName)"
}

Write-Host "✅ Export complete! JSON files stored in ./exports"
