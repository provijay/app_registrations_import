<#
.SYNOPSIS
    Exports all Azure AD App Registrations with all properties to a JSON file using AzureAD module
.DESCRIPTION
    This script connects to Azure AD using the AzureAD module, retrieves all application registrations
    with their complete set of properties, and exports them to a JSON file.
.PARAMETER OutputFile
    Path to the output JSON file (default: .\app-registrations-export.json)
.PARAMETER IncludeSecretsInfo
    Whether to include information about secrets (metadata only, not actual values)
#>

param(
    [string]$OutputFile = ".\app-registrations-export.json",
    [bool]$IncludeSecretsInfo = $true
)

# Function to test if AzureAD module is installed
function Test-AzureADModule {
    try {
        Import-Module AzureAD -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# Check if AzureAD module is installed
if (-not (Test-AzureADModule)) {
    Write-Host "AzureAD module not found. Installing..." -ForegroundColor Yellow
    try {
        Install-Module -Name AzureAD -Scope CurrentUser -Force -ErrorAction Stop
        Import-Module AzureAD -ErrorAction Stop
        Write-Host "AzureAD module installed successfully" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to install AzureAD module: $($_.Exception.Message)"
        Write-Host "Please install the AzureAD module manually using: Install-Module -Name AzureAD -Scope CurrentUser -Force" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "AzureAD module is already installed" -ForegroundColor Green
}

# Connect to Azure AD
try {
    Write-Host "Connecting to Azure AD..." -ForegroundColor Yellow
    $context = Get-AzureADCurrentSessionInfo -ErrorAction SilentlyContinue
    if (-not $context) {
        Connect-AzureAD -ErrorAction Stop
    }
    else {
        Write-Host "Already connected to Azure AD as $($context.Account.Id)" -ForegroundColor Green
    }
}
catch {
    Write-Error "Failed to connect to Azure AD: $($_.Exception.Message)"
    exit 1
}

# Get tenant information
try {
    $tenant = Get-AzureADTenantDetail
    $tenantId = $tenant.ObjectId
    $tenantName = $tenant.DisplayName
    Write-Host "Connected to tenant: $tenantName ($tenantId)" -ForegroundColor Green
}
catch {
    Write-Warning "Could not retrieve tenant details: $($_.Exception.Message)"
    $tenantId = "Unknown"
    $tenantName = "Unknown"
}

Write-Host "Retrieving all application registrations..." -ForegroundColor Yellow

# Retrieve all applications
try {
    $applications = Get-AzureADApplication -All $true -ErrorAction Stop
    Write-Host "Found $($applications.Count) application registrations" -ForegroundColor Green
}
catch {
    Write-Error "Failed to retrieve applications: $($_.Exception.Message)"
    Disconnect-AzureAD
    exit 1
}

# Process each application to get complete information
$processedApps = @()
$appCount = 0

foreach ($app in $applications) {
    $appCount++
    Write-Progress -Activity "Processing Applications" -Status "Processing $($app.DisplayName) ($appCount/$($applications.Count))" -PercentComplete (($appCount / $applications.Count) * 100)
    
    try {
        # Get the complete application object with all properties
        $fullApp = Get-AzureADApplication -ObjectId $app.ObjectId
        
        # Get application owners
        $owners = @()
        try {
            $ownerObjects = Get-AzureADApplicationOwner -ObjectId $app.ObjectId -ErrorAction SilentlyContinue
            $owners = @($ownerObjects | ForEach-Object {
                @{
                    ObjectId = $_.ObjectId
                    DisplayName = $_.DisplayName
                    UserPrincipalName = $_.UserPrincipalName
                    UserType = $_.UserType
                }
            })
        }
        catch {
            $owners = @("Error retrieving owners: $($_.Exception.Message)")
        }
        
        # Get service principal information
        $servicePrincipal = $null
        try {
            $sp = Get-AzureADServicePrincipal -Filter "AppId eq '$($app.AppId)'" -ErrorAction SilentlyContinue
            if ($sp) {
                $servicePrincipal = @{
                    ObjectId = $sp.ObjectId
                    DisplayName = $sp.DisplayName
                    AppDisplayName = $sp.AppDisplayName
                    AccountEnabled = $sp.AccountEnabled
                    ServicePrincipalType = $sp.ServicePrincipalType
                }
            }
        }
        catch {
            $servicePrincipal = "Error retrieving service principal: $($_.Exception.Message)"
        }
        
        # Create application object with all properties
        $appObject = @{
            ObjectId = $fullApp.ObjectId
            AppId = $fullApp.AppId
            DisplayName = $fullApp.DisplayName
            Description = $fullApp.Description
            PublisherDomain = $fullApp.PublisherDomain
            SignInAudience = $fullApp.SignInAudience
            IdentifierUris = $fullApp.IdentifierUris
            ReplyUrls = $fullApp.ReplyUrls
            LogoutUrl = $fullApp.LogoutUrl
            Oauth2AllowImplicitFlow = $fullApp.Oauth2AllowImplicitFlow
            Oauth2AllowUrlPathMatching = $fullApp.Oauth2AllowUrlPathMatching
            Oauth2Permissions = $fullApp.Oauth2Permissions
            AppRoles = $fullApp.AppRoles
            OptionalClaims = $fullApp.OptionalClaims
            SamlMetadataUrl = $fullApp.SamlMetadataUrl
            PasswordCredentials = if ($IncludeSecretsInfo) { $fullApp.PasswordCredentials } else { "REDACTED" }
            KeyCredentials = if ($IncludeSecretsInfo) { $fullApp.KeyCredentials } else { "REDACTED" }
            RequiredResourceAccess = $fullApp.RequiredResourceAccess
            GroupMembershipClaims = $fullApp.GroupMembershipClaims
            AcceptMappedClaims = $fullApp.AcceptMappedClaims
            KnownClientApplications = $fullApp.KnownClientApplications
            PreAuthorizedApplications = $fullApp.PreAuthorizedApplications
            RecordConsentConditions = $fullApp.RecordConsentConditions
            Oauth2Permissions = $fullApp.Oauth2Permissions
            InformationalUrls = $fullApp.InformationalUrls
            Owners = $owners
            ServicePrincipal = $servicePrincipal
        }
        
        $processedApps += $appObject
    }
    catch {
        Write-Warning "Failed to process application $($app.DisplayName): $($_.Exception.Message)"
        # Add basic app info even if full processing fails
        $processedApps += @{
            ObjectId = $app.ObjectId
            AppId = $app.AppId
            DisplayName = $app.DisplayName
            Error = "Failed to retrieve complete information: $($_.Exception.Message)"
        }
    }
}

# Create final export object
$exportData = @{
    ExportDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    TenantId = $tenantId
    TenantName = $tenantName
    TotalApplications = $processedApps.Count
    Applications = $processedApps
}

# Export to JSON file
try {
    $jsonContent = $exportData | ConvertTo-Json -Depth 10
    $jsonContent | Out-File -FilePath $OutputFile -Encoding UTF8
    Write-Host "Successfully exported $($processedApps.Count) applications to: $OutputFile" -ForegroundColor Green
    Write-Host "File size: $([math]::Round((Get-Item $OutputFile).Length/1KB, 2)) KB" -ForegroundColor Green
}
catch {
    Write-Error "Failed to export to JSON: $($_.Exception.Message)"
}

# Disconnect from Azure AD
try {
    Disconnect-AzureAD -ErrorAction SilentlyContinue
    Write-Host "Disconnected from Azure AD" -ForegroundColor Yellow
}
catch {
    Write-Warning "Error disconnecting from Azure AD: $($_.Exception.Message)"
}

# Show sample of the exported data
if (Test-Path $OutputFile) {
    Write-Host "`nSample of exported data:" -ForegroundColor Cyan
    try {
        $sampleData = Get-Content $OutputFile -Raw | ConvertFrom-Json
        if ($sampleData.Applications.Count -gt 0) {
            Write-Host "First application:" -ForegroundColor Yellow
            $sampleData.Applications[0] | Select-Object DisplayName, AppId, ObjectId, SignInAudience | Format-List
        }
    }
    catch {
        Write-Warning "Could not display sample data: $($_.Exception.Message)"
    }
}

Write-Host "`nExport completed successfully!" -ForegroundColor Green
