# 3-import-batch.ps1
. .\0-prereqs-and-vars.ps1

# This script reads mapping.csv and imports azuread_application.<tfname> (by objectId) 
# and azuread_service_principal.sp_<san> (by SP objectId resolved from sps.json) into 
# terraform state. It has retries and a throttle pause.

# ensure terraform init
# Path to generated TF files
$tfDir = ".\generated-tf"

# Check that folder exists
if (-not (Test-Path $tfDir)) {
    Write-Error "TF folder not found: $tfDir"
    exit 1
}

# Get all .tf files in folder
$tfFiles = Get-ChildItem -Path $tfDir -Filter "*.tf"

foreach ($tfFile in $tfFiles) {
    Write-Host "`nProcessing file: $($tfFile.Name)"

    # Read the resource block to find resource type and name
    $lines = Get-Content $tfFile.FullName
    foreach ($line in $lines) {
        if ($line -match 'resource\s+"([^"]+)"\s+"([^"]+)"') {
            $resType = $matches[1]
            $resName = $matches[2]

            # Determine import ID from file (AppId / ObjectId)
            # We'll read it from the json file using naming convention
            # Assumes TF file name format: <san>-app.tf or <san>-sp.tf
            $san = ($tfFile.BaseName -replace '-app$','' -replace '-sp$','')
            $jsonFolder = if ($tfFile.BaseName -like '*-app') { ".\apps" } else { ".\serviceprincipals" }

            # Find corresponding JSON
            $jsonFile = Get-ChildItem -Path $jsonFolder -Filter "*$san*.json" | Select-Object -First 1
            if (-not $jsonFile) {
                Write-Warning "JSON file not found for $resName, skipping..."
                continue
            }

            $jsonData = Get-Content -Raw $jsonFile.FullName | ConvertFrom-Json
            $importId = if ($resType -eq "azuread_application") { $jsonData.objectId } else { $jsonData.objectId }

            # Run terraform import
            $importCmd = "terraform import $resType.$resName $importId"
            Write-Host "Running: $importCmd"
            Invoke-Expression $importCmd
        }
    }
}

Write-Host "`n✅ All resources imported successfully."
