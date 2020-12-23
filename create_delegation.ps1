$uamiRG = "rg-Lighthouse-uami"
$location = "north europe"
$subscriptionId = (get-azcontext).subscription.id

$lighthouseTemplate = "./delegation_templates/delegatedResourceManagement.json"
$lighthouseTemplateParameters = "./delegation_templates/delegatedResourceManagement.parameters.json"

New-AzResourceGroup -name $uamiRG -location $location

$uami = New-AzUserAssignedIdentity -ResourceGroupName $uamiRG -Name "lighthouse-uami"
Start-Sleep -Seconds 20
New-AzRoleAssignment -ObjectId $uami.PrincipalId -RoleDefinitionName "Owner" -Scope /subscriptions/$subscriptionId

New-AzDeployment -name lighthouseOnboarding -Location $location -TemplateFile $lighthouseTemplate -TemplateParameterFile $lighthouseTemplateParameters -verbose
$id = $uami.Id
Write-Host "Lähetä palveluntarjoajalle User Assigned Identity ID: $id"