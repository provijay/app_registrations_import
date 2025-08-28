# 1-export-entraid.ps1
. .\0-prereqs-and-vars.ps1
# Exports the full set of application and service principal properties to JSON and owners to CSV.

# Ensure Microsoft.Graph module
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
}

# Connect interactively (scopes required)
Write-Host "Connecting to Microsoft Graph - you will be prompted to authenticate..."
Connect-MgGraph -Scopes "Application.Read.All","Directory.Read.All","Application.ReadWrite.All" -UseDeviceAuthentication:$false

# Export all applications
Write-Host "Exporting applications to $ExportAppsJson ..."
$appList = Get-MgApplication -All
$appList | ConvertTo-Json -Depth 10 | Out-File -FilePath $ExportAppsJson -Encoding utf8

# Export all service principals (useful to find SP objectIds)
Write-Host "Exporting service principals to $ExportSPsJson ..."
$spList = Get-MgServicePrincipal -All
$spList | ConvertTo-Json -Depth 10 | Out-File -FilePath $ExportSPsJson -Encoding utf8

# Export owners per app into CSV mapping for quick lookups
Write-Host "Exporting owners per application to CSV ..."
$owners = @()
foreach ($app in $appList) {
    $appOwners = Get-MgApplicationOwnerByRef -ApplicationId $app.Id -All -ErrorAction SilentlyContinue
    foreach ($o in $appOwners) {
        $owners += [pscustomobject]@{
            appObjectId = $app.Id
            appDisplayName = $app.DisplayName
            ownerId = $o.Id
            ownerType = $o.ODataType -replace '#Microsoft.Graph.',''
            ownerDisplayName = $o.DisplayName
        }
    }
}
$owners | Export-Csv -Path $ExportOwnersCsv -NoTypeInformation -Encoding utf8

Write-Host "Export complete. Files:"
Write-Host "  $ExportAppsJson"
Write-Host "  $ExportSPsJson"
Write-Host "  $ExportOwnersCsv"
