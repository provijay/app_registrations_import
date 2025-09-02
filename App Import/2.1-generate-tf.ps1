param (
    [string]$AppsFolder = ".\apps",
    [string]$SPsFolder  = ".\serviceprincipals",
    [string]$OutputFolder = ".\generated-tf"
)

# Ensure output folder exists
if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

function Convert-ToTerraformBlock {
    param (
        [string]$ResourceType,
        [string]$ResourceName,
        [hashtable]$JsonObject
    )

    $tf  = "resource `"$ResourceType`" `"$ResourceName`" {" + "`n"

    foreach ($key in $JsonObject.Keys) {
        if ($key -in @("passwordCredentials","keyCredentials")) {
            continue # Skip secrets
        }

        $value = $JsonObject[$key]

        if ($null -eq $value) { continue }

        switch ($value.GetType().Name) {
            "String" { 
                $tf += "  $key = `"$value`"" + "`n"
            }
            "Boolean" {
                $tf += "  $key = $($value.ToString().ToLower())" + "`n"
            }
            "Int32" {
                $tf += "  $key = $value" + "`n"
            }
            "Object[]" {
                $tf += "  $key = [" + "`n"
                foreach ($item in $value) {
                    if ($item -is [string]) {
                        $tf += "    `"$item`"," + "`n"
                    } elseif ($item -is [hashtable] -or $item -is [PSCustomObject]) {
                        $innerBlock = ($item | ConvertTo-Json -Depth 10 -Compress)
                        $tf += "    jsondecode(`"$innerBlock`")," + "`n"
                    }
                }
                $tf += "  ]" + "`n"
            }
            "Hashtable" {
                $jsonBlock = ($value | ConvertTo-Json -Depth 10 -Compress)
                $tf += "  $key = jsondecode(`"$jsonBlock`")" + "`n"
            }
            "PSCustomObject" {
                $jsonBlock = ($value | ConvertTo-Json -Depth 10 -Compress)
                $tf += "  $key = jsondecode(`"$jsonBlock`")" + "`n"
            }
            default {
                $tf += "  # Unhandled type for $key" + "`n"
            }
        }
    }

    $tf += "}" + "`n"
    return $tf
}

# Process Apps
Get-ChildItem -Path $AppsFolder -Filter *.json | ForEach-Object {
    $json = Get-Content $_.FullName | ConvertFrom-Json -Depth 100
    $name = ($_ | Split-Path -LeafBase)
    $tf   = Convert-ToTerraformBlock -ResourceType "azuread_application" -ResourceName $name -JsonObject $json
    Set-Content -Path (Join-Path $OutputFolder "$name-app.tf") -Value $tf
}

# Process Service Principals
Get-ChildItem -Path $SPsFolder -Filter *.json | ForEach-Object {
    $json = Get-Content $_.FullName | ConvertFrom-Json -Depth 100
    $name = ($_ | Split-Path -LeafBase)
    $tf   = Convert-ToTerraformBlock -ResourceType "azuread_service_principal" -ResourceName $name -JsonObject $json
    Set-Content -Path (Join-Path $OutputFolder "$name-sp.tf") -Value $tf
}

Write-Host "✅ Terraform files generated in $OutputFolder"
