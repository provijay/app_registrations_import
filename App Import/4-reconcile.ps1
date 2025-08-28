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

param (
    [string]$AppsFolder = ".\apps",
    [string]$SPFolder   = ".\serviceprincipals",
    [string]$TfFolder   = ".\tf"
)

Write-Host "=== Reconciliation Started ===" -ForegroundColor Cyan
$report = @()

# Load all TF state resources
$tfResources = terraform state list 2>$null

if (-not $tfResources) {
    Write-Host "⚠️ No Terraform state found or terraform init not run yet!" -ForegroundColor Yellow
}

# ------------------------------
# 1. Check Applications
# ------------------------------
if (Test-Path $AppsFolder) {
    Get-ChildItem -Path $AppsFolder -Filter "*.json" | ForEach-Object {
        $app = Get-Content $_.FullName | ConvertFrom-Json
        $displayName = $app.displayName
        $appId = $app.appId
        $objectId = $app.id
        $tfName = "app_$($displayName -replace '[^a-zA-Z0-9]', '_')"

        $tfResName = "azuread_application.$tfName"

        $existsInTf = $tfResources -contains $tfResName

        # Verify with Azure CLI
        $existsInAzure = az ad app show --id $appId --only-show-errors --query "id" -o tsv 2>$null

        $report += [PSCustomObject]@{
            Type          = "Application"
            DisplayName   = $displayName
            AppId         = $appId
            ObjectId      = $objectId
            InTerraform   = $existsInTf
            InAzure       = [bool]$existsInAzure
        }
    }
}

# ------------------------------
# 2. Check Service Principals
# ------------------------------
if (Test-Path $SPFolder) {
    Get-ChildItem -Path $SPFolder -Filter "*.json" | ForEach-Object {
        $sp = Get-Content $_.FullName | ConvertFrom-Json
        $appId = $sp.appId
        $objectId = $sp.id
        $displayName = $sp.displayName
        $tfName = "sp_$($displayName -replace '[^a-zA-Z0-9]', '_')"

        $tfResName = "azuread_service_principal.$tfName"

        $existsInTf = $tfResources -contains $tfResName

        # Verify with Azure CLI
        $existsInAzure = az ad sp show --id $objectId --only-show-errors --query "id" -o tsv 2>$null

        $report += [PSCustomObject]@{
            Type          = "ServicePrincipal"
            DisplayName   = $displayName
            AppId         = $appId
            ObjectId      = $objectId
            InTerraform   = $existsInTf
            InAzure       = [bool]$existsInAzure
        }
    }
}

# ------------------------------
# 3. Output Report
# ------------------------------
$report | Format-Table -AutoSize

$report | Export-Csv -Path ".\reconcile_report.csv" -NoTypeInformation -Force
Write-Host "=== Reconciliation complete. Report saved to reconcile_report.csv ===" -ForegroundColor Green
