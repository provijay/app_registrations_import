$appnames = @(
    "sp-pipeline-apply-infra-ua-001"
    #"sp-pipeline-apply-devlab-prod-001"
)

$owner = "302017e2-d479-408a-85c1-d0c6b9c57fe7"

$subscriptions = Get-AzSubscription

foreach ($appname in $appnames) {
    $application_obj_id = (Get-AzADApplication -DisplayName $appname).id
    $service_principal_obj_id = (Get-AzADServicePrincipal -DisplayName $appname).id

    try {
        az rest --method POST --uri "https://graph.microsoft.com/beta/servicePrincipals/$service_principal_obj_id/owners/`$ref" --body "{`"@odata.id`": `"https://graph.microsoft.com/v1.0/directoryObjects/$owner`"}"
    }
    catch {
        Write-Host "Error when trying to assign Owner to SP: $appname. Maybe it is already assigned?"
    }

    try {
        az rest --method POST --uri "https://graph.microsoft.com/beta/applications/$application_obj_id/owners/`$ref" --body "{`"@odata.id`": `"https://graph.microsoft.com/v1.0/directoryObjects/$owner`"}"
    }
    catch {
        Write-Host "Error when trying to assign Owner to Application: $appname. Maybe it is already assigned?"
    }  
}

foreach ($appname in $appnames) {
    $application_obj_id = (Get-AzADApplication -DisplayName $appname).id
    $service_principal_obj_id = (Get-AzADServicePrincipal -DisplayName $appname).id

    $allAssignments = @()

    foreach ($sub in $subscriptions) {
        Set-AzContext -SubscriptionId $sub.Id

        $assignments = Get-AzRoleAssignment -ObjectId $service_principal_obj_id -ErrorAction SilentlyContinue

        if ($assignments) {
            $allAssignments += $assignments
        }
    }

    $uniqueAssignments = $allAssignments | Sort-Object RoleDefinitionName, RoleAssignmentId, Scope, ObjectId -Unique

    $federatedCredentials = Get-AzADAppFederatedCredential -ApplicationObjectId $application_obj_id


    Write-Host "Service principal: $($appname)"

    Write-Host "module `"<TODO>`" {"
    Write-Host "  source = `"git::https://bis.ghe.com/bis/cnc-terraform-service-principal-module`""
    Write-Host ""
    Write-Host "  name   = `"$($appname)`""
    Write-Host "  owners = [data.azuread_service_principal.apply_identity.object_id]"
    Write-Host ""
    Write-Host "  role_assignments = {"
    foreach ($assignment in $uniqueAssignments) {
        Write-Host "    `"$($assignment.RoleDefinitionName)`" : {"
        Write-Host "      scope                = `"$($assignment.Scope)`""
        Write-Host "      role_definition_name = `"$($assignment.RoleDefinitionName)`""
        Write-Host "    }"
    }
    Write-Host "  }"
    Write-Host ""
    Write-Host "  federated_credentials = {"
    foreach ($credential in $federatedCredentials) {
        Write-Host "    `"$($credential.Name)`" : {"
        Write-Host "      subject = `"$($credential.Subject)`""
        Write-Host "    }"
    }
    Write-Host "  }"
    Write-Host "}"

    Write-Host "Imports:"
    Write-Host "import {"
    Write-Host "  to = module.<TODO>.azuread_application.this"
    Write-Host "  id = `"/applications/$application_obj_id`""
    Write-Host "}"
    Write-Host "import {"
    Write-Host "  to = module.<TODO>.azuread_service_principal.this"
    Write-Host "  id = `"$service_principal_obj_id`""
    Write-Host "}"
    foreach ($assignment in $uniqueAssignments) {
        Write-Host "import {"
        Write-Host "  to = module.<TODO>.azurerm_role_assignment.this[`"$($assignment.RoleDefinitionName)`"]"
        Write-Host "  id = `"$($assignment.RoleAssignmentId)`""
        Write-Host "}"
    }
    foreach ($credential in $federatedCredentials) {
        Write-Host "import {"
        Write-Host "  to = module.<TODO>.azuread_application_federated_identity_credential.this[`"$($credential.Name)`"]"
        Write-Host "  id = `"$application_obj_id/federatedIdentityCredential/$($credential.Id)`""
        Write-Host "}"
    }

}