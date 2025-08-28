# 0-prereqs-and-vars.ps1
# Edit these variables before running the pipeline scripts.

# Working directory (where files will be placed)
$WorkDir = "C:\projects\entra-tf"
New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null

# Exports
$ExportAppsJson = Join-Path $WorkDir "exports\apps.json"
$ExportSPsJson  = Join-Path $WorkDir "exports\sps.json"
$ExportOwnersCsv = Join-Path $WorkDir "exports\owners.csv"

# TF generation output
$TfOutDir = Join-Path $WorkDir "generated"
$MappingCsv = Join-Path $WorkDir "mapping.csv"

# Terraform root (where backend.tf / provider.tf will live)
$TerraformRoot = $WorkDir

# Terraform binary name (if terraform in PATH)
$TerraformCmd = "terraform"

# Throttle / import settings
$ImportBatchSize = 10   # number of concurrent imports to attempt (script will do sequential with pauses)
$ImportPauseSeconds = 2 # pause between imports to avoid Graph throttling
$MaxImportRetries = 5   # per resource

# Backend settings (edit backend.tf with same values)
$BackendResourceGroup = "tfstate-rg"
$BackendStorageAccount = "tfstateacct"
$BackendContainer = "tfstate"
$BackendKey = "entra-apps.terraform.tfstate"

# Make directories
New-Item -ItemType Directory -Force -Path (Join-Path $WorkDir "exports") | Out-Null
New-Item -ItemType Directory -Force -Path $TfOutDir | Out-Null
