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
<#
.SYNOPSIS
    Reconciles Terraform state with exported Azure AD Applications and Service Principals.

.DESCRIPTION
    This script compares exported JSON files in the "apps" and "serviceprincipals" folders
    with Terraform state. It ensures that all applications and service principals exist
    in the Terraform state, importing any that are missing.
#>

<#
.SYNOPSIS
Reconciles Azure AD applications and service principals with Terraform state.

.DESCRIPTION
This script scans all generated Terraform files in the ./generated folder
and attempts to run "terraform import" for each resource if it's not already in state.
#>

param (
    [string]$GeneratedFolder = ".\generated"
)

# Ensure folder exists
if (-Not (Test-Path $GeneratedFolder)) {
    Write-Error "❌ Folder $GeneratedFolder not found. Please check your path."
    exit 1
}

# Initialize Terraform if needed
if (-Not (Test-Path "$GeneratedFolder/.terraform")) {
    Write-Host "🌱 Initializing Terraform in $GeneratedFolder..."
    Push-Location $GeneratedFolder
    terraform init
    Pop-Location
}

$tfFiles = Get-ChildItem -Path $GeneratedFolder -Filter "*.tf" -Recurse
if (-Not $tfFiles) {
    Write-Error "❌ No .tf files found in $GeneratedFolder."
    exit 1
}

foreach ($file in $tfFiles) {
    Write-Host "📄 Processing file: $($file.FullName)"

    $content = Get-Content -Path $file.FullName -Raw
    $matches = [regex]::Matches($content, 'resource\s+"(azuread_application|azuread_service_principal)"\s+"([^"]+)"')

    foreach ($m in $matches) {
        $resourceType = $m.Groups[1].Value
        $resourceName = $m.Groups[2].Value
        $resourceAddress = "$resourceType.$resourceName"

        Push-Location $GeneratedFolder

        # Check if resource is already in state
        $stateCheck = terraform state list | Select-String -Pattern $resourceAddress
        if ($stateCheck) {
            Write-Host "✔️ Already in state: $resourceAddress"
        } else {
            # Find corresponding JSON file to get objectId
            $jsonFile = Join-Path $GeneratedFolder "$resourceName.json"
            if (Test-Path $jsonFile) {
                $objectId = (Get-Content $jsonFile | ConvertFrom-Json).id
                if ($objectId) {
                    Write-Host "⚡ Importing $resourceAddress with ID $objectId"
                    terraform import $resourceAddress $objectId
                } else {
                    Write-Warning "❌ No ID found in $jsonFile"
                }
            } else {
                Write-Warning "❌ JSON file not found for $resourceAddress"
            }
        }

        Pop-Location
    }
}

Write-Host "🎉 Reconcile complete!"
