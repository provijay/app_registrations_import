# 3-import-batch.ps1
. .\0-prereqs-and-vars.ps1

# This script reads mapping.csv and imports azuread_application.<tfname> (by objectId) 
# and azuread_service_principal.sp_<san> (by SP objectId resolved from sps.json) into 
# terraform state. It has retries and a throttle pause.

# ensure terraform init
Push-Location $TerraformRoot
Write-Host "Running terraform init (backend must be configured in backend.tf)..."
& $TerraformCmd init
Pop-Location

$map = Import-Csv -Path $MappingCsv

# load SPs to find service principal objectId by appId
$spJson = Get-Content -Raw -Path $ExportSPsJson | ConvertFrom-Json

# function for retry
function Retry-Command($ScriptBlock, $Attempts, $SleepSeconds) {
    for ($i=1; $i -le $Attempts; $i++) {
        try {
            & $ScriptBlock
            return $true
        } catch {
            Write-Warning "Attempt $i failed: $($_.Exception.Message)"
            if ($i -lt $Attempts) { Start-Sleep -Seconds $SleepSeconds }
        }
    }
    return $false
}

foreach ($row in $map) {
    $tfname = $row.tf_resource_name
    $appObjectId = $row.objectId
    $appId = $row.applicationId
    Write-Host "`nImporting application TF resource: azuread_application.$tfname -> objectId $appObjectId"

    $importCmd = { & $TerraformCmd import ("azuread_application." + $tfname) $appObjectId }
    $ok = Retry-Command $importCmd $MaxImportRetries 2
    if (-not $ok) {
        Write-Error "Failed to import azuread_application.$tfname after $MaxImportRetries attempts. Skipping."
        continue
    }

    # find SP object for this appId
    $sp = $spJson | Where-Object { $_.appId -eq $appId } | Select-Object -First 1
    if ($sp -ne $null) {
        $spObjectId = $sp.id
        $spTfName = "sp_" + ($tfname -replace '^app_','')  # consistent with generator sp_<san>
        Write-Host "Importing service principal azuread_service_principal.$spTfName -> objectId $spObjectId"
        $importSpCmd = { & $TerraformCmd import ("azuread_service_principal." + $spTfName) $spObjectId }
        $ok2 = Retry-Command $importSpCmd $MaxImportRetries 2
        if (-not $ok2) {
            Write-Warning "Failed to import SP for $tfname. Continue."
        }
    } else {
        Write-Host "No service principal found for appId $appId (skipping SP import)."
    }

    # small pause to avoid Graph throttling
    Start-Sleep -Seconds $ImportPauseSeconds
}

Write-Host "`nImport pass complete. Now run 'terraform plan' in the Terraform root and review diffs."
