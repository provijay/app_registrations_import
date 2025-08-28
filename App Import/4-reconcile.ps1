# Compares exported JSON attributes vs terraform state and writes a 
# CSV of differences for key properties: displayName, sign_in_audience, 
# redirect URIs, appRoles count, oauth2 scopes count. This is a basic parity check you can expand.

# 4-reconcile.ps1
. .\0-prereqs-and-vars.ps1

Push-Location $TerraformRoot
# get terraform state in JSON
Write-Host "Exporting terraform state to JSON..."
$tfStateJson = & $TerraformCmd show -json | Out-String
Pop-Location

$tfState = $tfStateJson | ConvertFrom-Json
$appExports = Get-Content -Raw -Path $ExportAppsJson | ConvertFrom-Json
$mapping = Import-Csv -Path $MappingCsv

$report = @()

foreach ($m in $mapping) {
    $tfname = $m.tf_resource_name
    $appObjId = $m.objectId
    $appId = $m.applicationId

    # find Terraform resource in state by reference type + name
    $tfResource = $tfState.values.root_module.resources | Where-Object { $_.type -eq "azuread_application" -and $_.name -eq $tfname } | Select-Object -First 1
    if (-not $tfResource) {
        $report += [pscustomobject]@{ tfname=$tfname; status="missing_in_state" ; note="Resource not in terraform state" }
        continue
    }

    # find the source export by object id
    $exportApp = $appExports | Where-Object { $_.id -eq $appObjId } | Select-Object -First 1
    if (-not $exportApp) {
        $report += [pscustomobject]@{ tfname=$tfname; status="missing_in_export"; note="App not found in export JSON" }
        continue
    }

    # helper to extract attributes from tf state
    $attrs = $tfResource.values

    # compare fields
    $differences = @()

    if ($attrs.display_name -ne $exportApp.displayName) { $differences += "displayName" }
    if ($attrs.sign_in_audience -ne $exportApp.signInAudience) { $differences += "sign_in_audience" }

    # compare web redirect URIs (as unordered sets)
    $tf_web_redirects = @()
    if ($attrs.web -ne $null -and $attrs.web.redirect_uris -ne $null) { $tf_web_redirects = $attrs.web.redirect_uris }
    $exp_web_redirects = @()
    if ($exportApp.web -ne $null -and $exportApp.web.redirectUris -ne $null) { $exp_web_redirects = $exportApp.web.redirectUris }
    if ((Compare-Object -ReferenceObject $tf_web_redirects -DifferenceObject $exp_web_redirects) -ne $null) { $differences += "web.redirect_uris" }

    # app roles count
    $tf_app_roles_count = 0
    if ($attrs.api -ne $null -and $attrs.api.app_roles -ne $null) { $tf_app_roles_count = $attrs.api.app_roles.Count }
    $exp_app_roles_count = 0
    if ($exportApp.api -ne $null -and $exportApp.api.appRoles -ne $null) { $exp_app_roles_count = $exportApp.api.appRoles.Count }
    if ($tf_app_roles_count -ne $exp_app_roles_count) { $differences += "api.app_roles.count" }

    # oauth2 scopes count
    $tf_scopes_count = 0
    if ($attrs.api -ne $null -and $attrs.api.oauth2_permission_scopes -ne $null) { $tf_scopes_count = $attrs.api.oauth2_permission_scopes.Count }
    $exp_scopes_count = 0
    if ($exportApp.api -ne $null -and $exportApp.api.oauth2PermissionScopes -ne $null) { $exp_scopes_count = $exportApp.api.oauth2PermissionScopes.Count }
    if ($tf_scopes_count -ne $exp_scopes_count) { $differences += "api.oauth2_permission_scopes.count" }

    if ($differences.Count -eq 0) {
        $report += [pscustomobject]@{ tfname=$tfname; status="ok"; differences="" }
    } else {
        $report += [pscustomobject]@{ tfname=$tfname; status="mismatch"; differences=($differences -join "; ") }
    }
}

# write report
$reportCsv = Join-Path $WorkDir "reconcile-report.csv"
$report | Export-Csv -Path $reportCsv -NoTypeInformation -Encoding utf8

Write-Host "Reconcile complete. Report: $reportCsv"
