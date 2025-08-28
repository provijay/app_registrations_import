# 2-generate-tf.ps1
. .\0-prereqs-and-vars.ps1


# Generates TF files. The generator tries to map main fields: display_name, 
# sign_in_audience, web, spa, publicClient (native), 
# required_resource_access, api.app_roles, api.oauth2PermissionScopes. 
# It writes a mapping CSV linking TF resource name to objectId and appId.


# 2-generate-tf.ps1
# Generates .tf files for AzureAD App Registrations and Service Principals

$appsFile  = ".\applications.json"
$spsFile   = ".\serviceprincipals.json"
$outDir    = ".\generated-tf"

if (-not (Test-Path $appsFile)) { Write-Error "Missing $appsFile"; exit 1 }
if (-not (Test-Path $spsFile))  { Write-Error "Missing $spsFile";  exit 1 }

# Make sure output directory exists
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

Write-Host "Reading application registrations..."
$apps = Get-Content $appsFile | ConvertFrom-Json

Write-Host "Reading service principals..."
$sps = Get-Content $spsFile | ConvertFrom-Json

# --- Function: sanitize names for TF ---
function Sanitize-Name($name) {
    return ($name -replace '[^a-zA-Z0-9]', "_").ToLower()
}

# --- Applications ---
foreach ($app in $apps) {
    $san = Sanitize-Name $app.displayName
    $tfPath = Join-Path $outDir "$san-app.tf"

    $tf = @()
    $tf += "resource \"azuread_application\" \"$san\" {"
    $tf += "  display_name     = \"${app.displayName}\""
    $tf += "  application_id   = \"${app.appId}\""

    if ($app.identifierUris -and $app.identifierUris.Count -gt 0) {
        $tf += "  identifier_uris = ["
        foreach ($uri in $app.identifierUris) {
            $tf += "    \"$uri\","
        }
        $tf += "  ]"
    }

    if ($app.web.redirectUris -and $app.web.redirectUris.Count -gt 0) {
        $tf += "  web {"
        $tf += "    redirect_uris = ["
        foreach ($r in $app.web.redirectUris) {
            $tf += "      \"$r\","
        }
        $tf += "    ]"
        $tf += "  }"
    }

    $tf += ""
    $tf += "  lifecycle {"
    $tf += "    ignore_changes = ["
    $tf += "      owners,"
    $tf += "      required_resource_access,"
    $tf += "    ]"
    $tf += "  }"
    $tf += "}"

    # --- Application owners ---
    if ($app.owners -and $app.owners.Count -gt 0) {
        foreach ($owner in $app.owners) {
            $ownerSan = Sanitize-Name $owner
            $tf += ""
            $tf += "resource \"azuread_application_owner\" \"${san}_${ownerSan}\" {"
            $tf += "  application_object_id = azuread_application.$san.object_id"
            $tf += "  owner_object_id       = \"$owner\""
            $tf += "}"
        }
    }

    $tf | Out-File -FilePath $tfPath -Encoding utf8
    Write-Host "Generated: $tfPath"
}

# --- Service Principals ---
foreach ($sp in $sps) {
    $san = Sanitize-Name $sp.displayName
    $tfPath = Join-Path $outDir "$san-sp.tf"

    $tf = @()
    $tf += "resource \"azuread_service_principal\" \"$san\" {"
    $tf += "  application_id   = \"${sp.appId}\""
    $tf += "  display_name     = \"${sp.displayName}\""

    $tf += ""
    $tf += "  lifecycle {"
    $tf += "    ignore_changes = ["
    $tf += "      owners,"
    $tf += "    ]"
    $tf += "  }"
    $tf += "}"

    # --- Service Principal owners ---
    if ($sp.owners -and $sp.owners.Count -gt 0) {
        foreach ($owner in $sp.owners) {
            $ownerSan = Sanitize-Name $owner
            $tf += ""
            $tf += "resource \"azuread_service_principal_owner\" \"${san}_${ownerSan}\" {"
            $tf += "  service_principal_object_id = azuread_service_principal.$san.object_id"
            $tf += "  owner_object_id             = \"$owner\""
            $tf += "}"
        }
    }

    $tf | Out-File -FilePath $tfPath -Encoding utf8
    Write-Host "Generated: $tfPath"
}

Write-Host "✅ TF files generated in $outDir"
