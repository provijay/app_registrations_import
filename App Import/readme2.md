High-level approach (summary)

Discovery / Export — Export all AppRegistration objects and related data (service principals, owners, API permissions, roles, redirect URIs, certs/secrets metadata, tags, reply urls, reply URIs, published scopes, appRoles, required_resource_access, etc.) using Microsoft Graph PowerShell and save to JSON.

Translate to Terraform skeleton — For each AppRegistration create corresponding azuread_application and azuread_service_principal TF resource blocks with exact attributes as in Entra (except secrets). Use modules and a predictable naming convention.

Prepare backend + state safety — Configure a remote backend (Azure Storage with locking) and backup current state file(s).

Import — For each object, run terraform import to load the existing Entra object into Terraform state.

Refine TF configs — Tweak TF configs to remove provider-computed differences, add lifecycle blocks when appropriate, and re-run terraform plan until there are no diffs.

Reconcile — Confirm terraform plan => no actions. Validate with Graph queries that all exported attributes match TF-managed state.

Operationalize — Add CI/CD checks, run in non-prod first, and implement KeyVault handling for secrets.

Below are detailed, actionable steps, commands and sample snippets.

Detailed step-by-step plan
0) Pre-reqs & environment

Ensure you have:

Terraform (compatible with azuread provider v3.3).

Microsoft.Graph PowerShell module (recommended) or az cli (note: az ad app is deprecated; Graph is preferred).

VS Code.

Access to the Entra tenant with Application.Read.All and Directory.Read.All (and AppRoleAssignment.ReadWrite.All if you plan to manage owners/assignments).

An Azure Storage Account + container for terraform backend with state locking enabled (recommended for multi-user safety).

Create a service principal or your user with sufficient Graph permissions and consent.

1) Discovery / Export (source of truth)

Use Microsoft Graph PowerShell to export all app registrations and related objects:

PowerShell example:

Install-Module Microsoft.Graph -Scope CurrentUser -Force
Import-Module Microsoft.Graph.Applications
# interactive auth with required scopes
Connect-MgGraph -Scopes "Application.Read.All","Directory.Read.All","AppRoleAssignment.Read.All"

# Export applications (all pages) with deep properties
Get-MgApplication -All | Select-Object * | ConvertTo-Json -Depth 10 > C:\temp\entra_apps_raw.json

# Export service principals (if you have SPs matching apps)
Get-MgServicePrincipal -All | Select-Object * | ConvertTo-Json -Depth 10 > C:\temp\entra_sps_raw.json

# Export owners (mapping)
Get-MgApplicationOwnerByRef -ApplicationId <app-object-id>  # (use scripting below to iterate)


Notes:

Save both applications and service principals. Some apps may not have SPs; some may.

-Depth 10 to capture nested objects (appRoles, oauth2PermissionScopes, requiredResourceAccess, keyCredentials, passwordCredentials, web/SPA/native redirect URIs, etc.).

Why JSON export first: it’s your immutable source-of-truth and lets you generate TF configuration programmatically and audit.

2) Generate Terraform skeletons from JSON

You can create TF files with a script that maps JSON fields to Terraform attributes. I recommend generating one folder per app (or one file per app) and a map-based module if you prefer.

Minimal azuread_application TF example (sample)
resource "azuread_application" "app_<sanitized_name>" {
  display_name = "My App Name"
  sign_in_audience = "AzureADMyOrg" # or "AzureADMultipleOrgs"
  owners = [ "00000000-0000-0000-0000-000000000000" ] # optional, import later
  # optional: web, spa, native, api blocks
  web {
    redirect_uris = ["https://example.com/auth/callback"]
    logout_url    = "https://example.com/logout"
  }
  spa {
    redirect_uris = []
  }
  required_resource_access = [
    {
      resource_app_id = "00000000-0000-0000-0000-000000000000"
      resource_access = [{
        id   = "scope-or-role-id"
        type = "Scope" # or "Role"
      }]
    }
  ]
  # app_roles, api, etc.
  # DO NOT include password credentials (secrets) in TF plaintext.
}

Service principal TF example:
resource "azuread_service_principal" "sp_<sanitized_name>" {
  application_id = azuread_application.app_<sanitized_name>.application_id
  # optional: owners, app_role_assignment blocks are separate resources
}


Automation approach

Write a PowerShell script or small Node/Python script to:

Read entra_apps_raw.json.

Sanitize displayName into TF resource name (replace spaces, special chars).

Emit resources/*.tf with the attributes (web, spa, native, api, appRoles, required_resource_access).

Emit a mapping file mapping.csv with displayName, objectId, applicationId, tf_resource_name.

I’ll include a basic PowerShell template you can expand later.

PowerShell (rough generator skeleton — adjust fields as needed):

$apps = Get-Content C:\temp\entra_apps_raw.json | ConvertFrom-Json
$outDir = "C:\projects\entra-tf\apps"
New-Item -ItemType Directory -Force -Path $outDir

foreach ($app in $apps) {
  $name = $app.displayName -replace '[^a-zA-Z0-9_-]','_' -replace '__+','_'
  $file = Join-Path $outDir ("app_" + $name + ".tf")
  $tf = @()
  $tf += "resource ""azuread_application"" ""app_$name"" {"
  $tf += "  display_name = ""$($app.displayName)"""
  $tf += "  sign_in_audience = ""$($app.signInAudience)"""
  if ($app.web) {
    $redirects = ($app.web.redirectUris -join '","')
    $tf += "  web {"
    $tf += "    redirect_uris = [""$redirects""]"
    if ($app.web.logoutUrl) { $tf += "    logout_url = ""$($app.web.logoutUrl)""" }
    $tf += "  }"
  }
  # TODO: add api, spa, native, appRoles, required_resource_access mapping
  $tf += "}"
  $tf | Out-File -FilePath $file -Encoding utf8
  # record mapping somewhere
}


Important: Do not include passwordCredentials (secrets) values in TF. You may include metadata for expired/active keys without secret values, or create new KeyVault-backed secrets for future use.

3) Backend & state safety (must do before imports)

Set up an Azure Storage backend with blob container and enable soft-delete / versioning for the storage container.

Configure terraform { backend "azurerm" { ... } } in your root workspace.

Backup current state: terraform state pull > backup-state-<timestamp>.json. Keep copies off-site.

Work in a dedicated Terraform workspace for this import to avoid clobbering existing infra states.

Sample backend snippet:

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateacct"
    container_name       = "tfstate"
    key                  = "entra-apps.terraform.tfstate"
  }
}

4) Import objects into Terraform state (the critical step)

The import sequence (recommended order):

azuread_application (object id)

azuread_service_principal (object id)

Owners assignments (if you plan to manage owners) and app role assignments as separate importable resources

Application passwords or certificate metadata — DO NOT import secret values. Instead import the fact a credential exists by its key id if provider supports it (or leave out and create new ones).

Import command examples

Assuming TF resource azuread_application.app_myapp:

# from your TF root
terraform import azuread_application.app_myapp <application-object-id>


For service principal:

terraform import azuread_service_principal.sp_myapp <service-principal-object-id>


Batch import script (PowerShell)

$mapping = Import-Csv C:\projects\entra-tf\mapping.csv
cd C:\projects\entra-tf

foreach ($row in $mapping) {
  $tfname = $row.tfname
  $objid = $row.objectId
  Write-Host "Importing $tfname -> $objid"
  # import app
  & terraform import "azuread_application.$tfname" $objid
  # find and import service principal by appId/objectId from SP list
  # & terraform import "azuread_service_principal.sp_$tfname" $spObjectId
}


Notes & gotchas

Use the object id as import key for azuread_application.

If terraform import errors due to identical resource names, ensure resource names in TF match what you used in the import command.

Rate limits: throttle imports or run in parallel with small batches to avoid Graph throttling.

If an object has multiple instances with same display name — ensure your mapping uses objectId to disambiguate.

5) Reconcile TF configuration to avoid diffs

After import, run:

terraform plan


You will likely see differences because:

Provider computes some attributes (e.g., object_id, appId, homepage default behavior).

Some fields in Entra are present but provider represents them differently (e.g., oauth2AllowImplicitFlow vs new SPA flow flags).

Secrets will be absent (we purposely didn’t import secret values) — provider may show planned changes.

How to get plan to show no changes:

Ensure your TF config lists exactly the same attributes and values as Entra for fields you manage.

For fields you will not manage or provider-computed fields, add:

lifecycle {
  ignore_changes = [ <field1>, <field2> ]
}


Examples: computed app IDs, oauth2_permission_scope IDs autogenerated, or publisher_domain which is read-only.

For attributes that differ in representation (arrays order, case), normalize in TF generator to match provider expected ordering and types.

Iterate:

Edit TF until terraform plan shows 0 changes.

If there are provider limitations (fields that cannot be set via TF but exist in Entra), document them and use ignore_changes or accept they’ll be unmanaged.

Key file to keep current: create reconcile-report.md that lists every attribute you had to ignore and why.

6) Special handling: secrets & certificates

Do NOT store secret values in Terraform source.

Options:

Create a separate process to rotate or re-create secrets and store them in Azure Key Vault. Use az keyvault set-policy and Terraform azurerm_key_vault_secret (but those are azurerm resources, not azuread).

Store metadata of passwords (key id, startDate, endDate), but not the secret value. If the provider supports password resource import without secret material, do so; otherwise exclude credentials from TF and manage them outside TF.

If you must keep secret values in TF for automation, use a secure pipeline variable store or KeyVault references — but prefer not to.

7) Owners, app role assignments, and permissions

Owners: can be exported and managed with azuread_application_owner or assign owners via Graph. Terraform azuread_application supports owners attribute (list of object ids). Import owners after app import:

terraform import azuread_application_owner.app_owner_<app> <app-object-id>/<owner-object-id>


App role assignments and required_resource_access: Convert requiredResourceAccess JSON to TF required_resource_access blocks.

API permissions: if you want Terraform to manage delegated app permissions and admin consent, you may want to manage them with separate resources or use azuread_service_principal assignments. Some actions require admin consent outside TF.

8) Validation & final reconciliation

After all imports and configuration tuning:

Run terraform plan until it reports no changes.

Run scripted Graph checks to compare key attributes between apps.json (export) and TF state (terraform state pull or terraform show -json) and verify parity.

Example PowerShell parity check idea:

Export terraform state to JSON and compare attributes (displayName, redirectUris, appRoles, requiredResourceAccess) against entra_apps_raw.json. Report differences.

9) Rollout & production hardening

Dry-run in a non-production tenant or dedicated test folder.

Use branch + PR workflow in GitHub or Azure DevOps. Require code review.

Add automated terraform plan validation step in CI to ensure plan is always no changes on the main branch after import.

Implement state locking and strict RBAC on the state storage account.

10) Post-import maintenance and notes

Document all ignore_changes uses — these are exceptions.

If you later need to rotate secrets, follow a process that creates new secrets (via CI pipeline) and updates KeyVault and the SP as needed.

For new apps, create via Terraform (authoritative source).

Consider implementing automated tests that run az rest or Graph queries to check app functionality.

Example minimal end-to-end flow (commands condensed)

Export:

Connect-MgGraph -Scopes "Application.Read.All","Directory.Read.All"
Get-MgApplication -All | ConvertTo-Json -Depth 10 > .\apps.json
Get-MgServicePrincipal -All | ConvertTo-Json -Depth 10 > .\sps.json


Generate TF skeletons (scripted — see generator skeleton above).

Initialize terraform with remote backend:

terraform init


Import apps (example single app):

terraform import azuread_application.app_myapp 11111111-2222-3333-4444-555555555555
terraform import azuread_service_principal.sp_myapp 66666666-7777-8888-9999-aaaaaaaaaaaa


Run plan, adjust TF until plan shows no actions:

terraform plan
# if plan shows diffs -> edit tf configs, or add lifecycle ignore_changes where acceptable


Validate parity with JSON exports and terraform state pull.

Edge cases and things to watch (explicit)

500 apps: batching & rate limits — import in small batches and include retries.

Duplicate display names: rely on objectId for uniqueness; sanitize TF resource names.

Provider attribute gaps or bugs: some App properties may not be supported by the provider or may be read-only. Document these and use ignore_changes.

Secrets/certs: never put secret values in repo. Use Key Vault.

Owners / Groups: importing owners or group role assignments may need separate import commands and will require owner object ids.

AppRoles & OAuth scopes: TF will manage them but note the IDs for scopes and roles can be autogenerated — ensure generator sets the same IDs if possible; otherwise TF may want to recreate them. If provider assigns IDs, you may need to import the resource that holds them or ignore those ID fields.

CI/CD: ensure only one pipeline runs plan/apply at a time (state lock).

Deliverables I’ll provide if you want me to proceed

(As you asked initially for a plan only — I did that above. If you want me to take the next steps I can deliver:)

A PowerShell exporter script that produces normalized JSON and mapping CSV (ready).

A TF generator script (PowerShell or Node) that produces .tf files per app, sanitized names and mapping.

A batch import PowerShell script that imports apps & SPs into state with retry/throttling logic.

A reconciliation script (PowerShell) that compares Entra exports vs terraform state and produces a report.

An opinionated terraform module layout + example backend configuration and CI YAML for GitHub Actions or Azure DevOps (if you want automation).

Final checklist before you run this plan (things to verify in your environment)

You have tenant admin or appropriate Graph privileges.

A safe Terraform backend (Azure Storage) is ready and you’ve backed up current state.

You accept that credentials (secrets) will be handled outside TF (recommended) or through a secure KeyVault process.

Decide whether owners and certain assignments should be managed by TF or left as read-only (we can manage them but they often cause extra work in import).