<#
.SYNOPSIS
    Exports all Azure AD App Registrations with all properties to a JSON file
.DESCRIPTION
    This script connects to Microsoft Graph, retrieves all application registrations
    with their complete set of properties, and exports them to a JSON file.
.PARAMETER OutputFile
    Path to the output JSON file (default: .\app-registrations-export.json)
.PARAMETER IncludeAllProperties
    Whether to include all available properties (default: $true)
#>

param(
    [string]$OutputFile = ".\app-registrations-export.json",
    [bool]$IncludeAllProperties = $true
)

# Check if Microsoft.Graph module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Installing Microsoft.Graph module..." -ForegroundColor Yellow
    Install-Module -Name Microsoft.Graph -Force -Scope CurrentUser
}

# Import required Microsoft.Graph modules
Import-Module Microsoft.Graph.Applications
Import-Module Microsoft.Graph.Users

# Connect to Microsoft Graph with required permissions
try {
    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Yellow
    Connect-MgGraph -Scopes "Application.Read.All", "User.Read.All", "Directory.Read.All" -ErrorAction Stop
    Write-Host "Connected to Microsoft Graph successfully" -ForegroundColor Green
}
catch {
    Write-Error "Failed to connect to Microsoft Graph: $($_.Exception.Message)"
    exit 1
}

# Get tenant information
$tenant = Get-MgOrganization
$tenantId = $tenant.Id
$tenantName = $tenant.DisplayName

Write-Host "Retrieving all application registrations from tenant: $tenantName ($tenantId)..." -ForegroundColor Yellow

# Retrieve all applications with all properties
$applications = @()
try {
    $apps = Get-MgApplication -All -Property "*" -ErrorAction Stop
    Write-Host "Found $($apps.Count) application registrations" -ForegroundColor Green
}
catch {
    Write-Error "Failed to retrieve applications: $($_.Exception.Message)"
    Disconnect-MgGraph
    exit 1
}

# Process each application to get additional information
$processedApps = @()
$appCount = 0

foreach ($app in $apps) {
    $appCount++
    Write-Progress -Activity "Processing Applications" -Status "Processing $($app.DisplayName) ($appCount/$($apps.Count))" -PercentComplete (($appCount / $apps.Count) * 100)
    
    # Create a custom object with all app properties
    $appObject = @{
        Id = $app.Id
        AppId = $app.AppId
        DisplayName = $app.DisplayName
        Description = $app.Description
        SignInAudience = $app.SignInAudience
        CreatedDateTime = $app.CreatedDateTime
        PublisherDomain = $app.PublisherDomain
        IdentifierUris = $app.IdentifierUris
        Web = $app.Web
        Spa = $app.Spa
        PublicClient = $app.PublicClient
        AppRoles = $app.AppRoles
        Info = $app.Info
        KeyCredentials = $app.KeyCredentials
        PasswordCredentials = $app.PasswordCredentials
        RequiredResourceAccess = $app.RequiredResourceAccess
        Api = $app.Api
        Oauth2RequirePostResponse = $app.Oauth2RequirePostResponse
        OptionalClaims = $app.OptionalClaims
        GroupMembershipClaims = $app.GroupMembershipClaims
        Tags = $app.Tags
        TokenEncryptionKeyId = $app.TokenEncryptionKeyId
        VerifiedPublisher = $app.VerifiedPublisher
        IsFallbackPublicClient = $app.IsFallbackPublicClient
        Notes = $app.Notes
        Logo = if ($app.Logo) { "Present" } else { "Not present" }
    }

    # Get application owners
    try {
        $owners = Get-MgApplicationOwner -ApplicationId $app.Id -ErrorAction SilentlyContinue
        $appObject.Owners = @($owners | ForEach-Object {
            @{
                Id = $_.Id
                DisplayName = $_.AdditionalProperties.displayName
                UserPrincipalName = $_.AdditionalProperties.userPrincipalName
                UserType = $_.AdditionalProperties.userType
            }
        })
    }
    catch {
        $appObject.Owners = @("Error retrieving owners: $($_.Exception.Message)")
    }

    # Get service principal for additional info
    try {
        $servicePrincipal = Get-MgServicePrincipal -Filter "appId eq '$($app.AppId)'" -ErrorAction SilentlyContinue
        if ($servicePrincipal) {
            $appObject.ServicePrincipal = @{
                Id = $servicePrincipal.Id
                DisplayName = $servicePrincipal.DisplayName
                AppDisplayName = $servicePrincipal.AppDisplayName
                AppOwnerOrganizationId = $servicePrincipal.AppOwnerOrganizationId
                AppRoleAssignmentRequired = $servicePrincipal.AppRoleAssignmentRequired
                AccountEnabled = $servicePrincipal.AccountEnabled
                AlternativeNames = $servicePrincipal.AlternativeNames
                ServicePrincipalType = $servicePrincipal.ServicePrincipalType
                SignInAudience = $servicePrincipal.SignInAudience
            }
        }
    }
    catch {
        $appObject.ServicePrincipal = "Error retrieving service principal: $($_.Exception.Message)"
    }

    $processedApps += $appObject
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

# Disconnect from Microsoft Graph
Disconnect-MgGraph
Write-Host "Disconnected from Microsoft Graph" -ForegroundColor Yellow

# Show sample of the exported data
if (Test-Path $OutputFile) {
    Write-Host "`nSample of exported data:" -ForegroundColor Cyan
    $sampleData = Get-Content $OutputFile -Raw | ConvertFrom-Json
    Write-Host "First application:" -ForegroundColor Yellow
    $sampleData.Applications[0] | Select-Object DisplayName, AppId, CreatedDateTime, SignInAudience | Format-List
}
