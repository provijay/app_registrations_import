# 2-generate-tf.ps1
. .\0-prereqs-and-vars.ps1


# Generates TF files. The generator tries to map main fields: display_name, 
# sign_in_audience, web, spa, publicClient (native), 
# required_resource_access, api.app_roles, api.oauth2PermissionScopes. 
# It writes a mapping CSV linking TF resource name to objectId and appId.


# read exported JSON
$apps = Get-Content -Raw -Path $ExportAppsJson | ConvertFrom-Json

# helper to sanitize names to TF resource names
function Sanitize-Name($n) {
    $s = $n -replace '[^a-zA-Z0-9]', '_'          # non-alphanumeric -> _
    $s = $s -replace '__+', '_'                   # collapse repeated underscores
    if ($s.Length -gt 64) { $s = $s.Substring(0,64) } # avoid extremely long names
    # ensure cannot start with digit for TF resource
    if ($s -match '^[0-9]') { $s = "app_$s" }
    return $s
}

$mapping = @()

foreach ($app in $apps) {
    $san = Sanitize-Name $app.displayName
    $tfname = "app_$san"
    $tfFile = Join-Path $TfOutDir ("azuread_application_" + $san + ".tf")

    $lines = @()
    $lines += "resource ""azuread_application"" `"$tfname`" {"
    $lines += "  display_name     = `"$($app.displayName)`""
    if ($app.signInAudience) {
        $lines += "  sign_in_audience = `"$($app.signInAudience)`""
    }

    # web block
    if ($app.web -ne $null) {
        $redirects = @()
        if ($app.web.redirectUris) { $redirects = $app.web.redirectUris }
        $lines += "  web {"
        if ($redirects.Count -gt 0) {
            $joined = $redirects | ForEach-Object { "`"$($_)`"" } -join ", "
            $lines += "    redirect_uris = [$joined]"
        }
        if ($app.web.logoutUrl) { $lines += "    logout_url = `"$($app.web.logoutUrl)`"" }
        $lines += "  }"
    }

    # spa
    if ($app.spa -ne $null -and $app.spa.redirectUris) {
        $redirects = $app.spa.redirectUris
        $joined = $redirects | ForEach-Object { "`"$($_)`"" } -join ", "
        $lines += "  spa {"
        $lines += "    redirect_uris = [$joined]"
        $lines += "  }"
    }

    # public client (native)
    if ($app.publicClient -ne $null -and $app.publicClient.redirectUris) {
        $redirects = $app.publicClient.redirectUris
        $joined = $redirects | ForEach-Object { "`"$($_)`"" } -join ", "
        $lines += "  public_client {"
        $lines += "    redirect_uris = [$joined]"
        $lines += "  }"
    }

    # required_resource_access
    if ($app.requiredResourceAccess -ne $null -and $app.requiredResourceAccess.Count -gt 0) {
        $lines += "  required_resource_access = ["
        foreach ($rra in $app.requiredResourceAccess) {
            $lines += "    {"
            $lines += "      resource_app_id = `"$($rra.resourceAppId)`""
            $lines += "      resource_access = ["
            foreach ($ra in $rra.resourceAccess) {
                $lines += "        { id = `"$($ra.id)`"; type = `"$($ra.type)`" },"
            }
            $lines += "      ]"
            $lines += "    },"
        }
        $lines += "  ]"
    }

    # api (app roles & oauth2 permission scopes)
    if ($app.api -ne $null) {
        if ($app.api.oauth2PermissionScopes -ne $null -and $app.api.oauth2PermissionScopes.Count -gt 0) {
            $lines += "  api {"
            $lines += "    oauth2_permission_scopes = ["
            foreach ($s in $app.api.oauth2PermissionScopes) {
                # note: provider may compute id if not provided; we include description and other metadata
                $displayName = $s.adminConsentDisplayName -or $s.displayName -or ""
                $lines += "      {"
                $lines += "        admin_consent_description = `"$($s.adminConsentDescription)`""
                $lines += "        admin_consent_display_name = `"$($s.adminConsentDisplayName)`""
                $lines += "        id = `"$($s.id)`""
                $lines += "        is_enabled = $($s.isEnabled)"
                $lines += "        type = `"$($s.type)`""
                $lines += "        user_consent_description = `"$($s.userConsentDescription)`""
                $lines += "        user_consent_display_name = `"$($s.userConsentDisplayName)`""
                $lines += "        value = `"$($s.value)`""
                $lines += "      },"
            }
            $lines += "    ]"
            $lines += "  }"
        }
        if ($app.api.appRoles -ne $null -and $app.api.appRoles.Count -gt 0) {
            # app roles block
            if (-not ($app.api.oauth2PermissionScopes)) { $lines += "  api {" } # create api block if not already
            $lines += "    app_roles = ["
            foreach ($ar in $app.api.appRoles) {
                $lines += "      {"
                $lines += "        allowed_member_types = [ " + ($ar.allowedMemberTypes | ForEach-Object { "`"$($_)`"" } -join ", ") + " ]"
                $lines += "        description = `"$($ar.description)`""
                $lines += "        display_name = `"$($ar.displayName)`""
                $lines += "        id = `"$($ar.id)`""
                $lines += "        is_enabled = $($ar.isEnabled)"
                $lines += "        value = `"$($ar.value)`""
                $lines += "      },"
            }
            $lines += "    ]"
            if (-not ($app.api.oauth2PermissionScopes)) { $lines += "  }" } else { $lines += "  }" }
        }
    }

    # close resource
    $lines += "}"

    # Write TF file
    $lines | Out-File -FilePath $tfFile -Encoding utf8

    # Add mapping row (appObjectId, appId)
    $mapping += [pscustomobject]@{
        tf_resource_name = $tfname
        displayName = $app.displayName
        objectId = $app.id
        applicationId = $app.appId
        tf_file = $tfFile
    }

    # also create a minimal sp TF file that references application_id
    $spFile = Join-Path $TfOutDir ("azuread_service_principal_" + $san + ".tf")
    $spLines = @()
   # $spLines += "resource ""azuread_service_principal"" `""sp_$san`" {"
   $spLines += ('resource "azuread_service_principal" "sp_{0}" {{' -f $san)
 
   $spLines += "  application_id = `"$($app.appId)`""
    $spLines += "}"
    $spLines | Out-File -FilePath $spFile -Encoding utf8
}

# write mapping CSV
$mapping | Export-Csv -Path $MappingCsv -NoTypeInformation -Encoding utf8

Write-Host "TF generation completed. Files written to: $TfOutDir"
Write-Host "Mapping CSV: $MappingCsv"
