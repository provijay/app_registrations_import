<#
.SYNOPSIS
    Exports Azure AD App Registrations to Terraform HCL configuration
.DESCRIPTION
    This script exports all Azure AD application registrations to Terraform HCL files,
    including secrets, certificates, API permissions, and other configurations.
.PARAMETER OutputDirectory
    Directory where Terraform files will be saved (default: .\terraform-app-registrations)
.PARAMETER SplitFiles
    Whether to split output into multiple files (default: $true)
.PARAMETER IncludeSecrets
    Whether to include client secrets in output (use with caution, as they will be in plain text)
#>

param(
    [string]$OutputDirectory = ".\terraform-app-registrations",
    [bool]$SplitFiles = $true,
    [bool]$IncludeSecrets = $false
)

# Check if AzureAD module is installed
if (-not (Get-Module -ListAvailable -Name AzureAD)) {
    Write-Host "Installing AzureAD module..." -ForegroundColor Yellow
    Install-Module -Name AzureAD -Force -Scope CurrentUser
}

# Import AzureAD module
Import-Module AzureAD

# Connect to Azure AD
try {
    $context = Get-AzureADCurrentSessionInfo -ErrorAction SilentlyContinue
    if (-not $context) {
        Write-Host "Connecting to Azure AD..." -ForegroundColor Yellow
        Connect-AzureAD
    }
    else {
        Write-Host "Already connected to Azure AD as $($context.Account.Id)" -ForegroundColor Green
    }
}
catch {
    Write-Error "Failed to connect to Azure AD: $($_.Exception.Message)"
    exit 1
}

# Create output directory if it doesn't exist
if (-not (Test-Path $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

# Get all applications
Write-Host "Retrieving all application registrations..." -ForegroundColor Yellow
$applications = Get-AzureADApplication -All $true

Write-Host "Found $($applications.Count) applications" -ForegroundColor Green

# Terraform main file content
$mainTerraformContent = @()
$mainTerraformContent += "# Terraform configuration for Azure AD App Registrations"
$mainTerraformContent += "# Generated on: $(Get-Date)"
$mainTerraformContent += "# Total applications: $($applications.Count)"
$mainTerraformContent += ""
$mainTerraformContent += "terraform {"
$mainTerraformContent += "  required_providers {"
$mainTerraformContent += "    azuread = {"
$mainTerraformContent += "      source  = `"hashicorp/azuread`""
$mainTerraformContent += "      version = `"~> 2.0`""
$mainTerraformContent += "    }"
$mainTerraformContent += "  }"
$mainTerraformContent += "}"
$mainTerraformContent += ""
$mainTerraformContent += "provider `"azuread`" {"
$mainTerraformContent += "  # Configure the Azure AD provider"
$mainTerraformContent += "  # tenant_id = `"your-tenant-id`" # Uncomment and set if needed"
$mainTerraformContent += "}"
$mainTerraformContent += ""

# Process each application
$appCount = 0
foreach ($app in $applications) {
    $appCount++
    Write-Progress -Activity "Processing Applications" -Status "Processing $($app.DisplayName) ($appCount/$($applications.Count))" -PercentComplete (($appCount / $applications.Count) * 100)
    
    # Sanitize app name for Terraform resource name
    $resourceName = ($app.DisplayName -replace '[^a-zA-Z0-9_]', '_' -replace '_+', '_').Trim('_')
    if ([string]::IsNullOrEmpty($resourceName)) {
        $resourceName = "app_$($app.ObjectId.Replace('-', '_'))"
    }
    
    # Get app owners
    $owners = Get-AzureADApplicationOwner -ObjectId $app.ObjectId
    
    # Get password credentials (secrets)
    $passwordCredentials = @()
    if ($IncludeSecrets) {
        $passwordCredentials = $app.PasswordCredentials | ForEach-Object {
            @{
                displayName = $_.CustomKeyIdentifier
                startDate   = $_.StartDate.ToString("o")
                endDate     = $_.EndDate.ToString("o")
                value       = "REDACTED" # Secrets cannot be retrieved after creation
            }
        }
    }
    
    # Get key credentials (certificates)
    $keyCredentials = $app.KeyCredentials | ForEach-Object {
        @{
            displayName = $_.CustomKeyIdentifier
            startDate   = $_.StartDate.ToString("o")
            endDate     = $_.EndDate.ToString("o")
            type        = $_.Type
            usage       = $_.Usage
        }
    }
    
    # Get API permissions
    $requiredResourceAccess = @()
   
