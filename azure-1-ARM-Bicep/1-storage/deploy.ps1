
# import log module
Import-Module .\Modules\LogModule\LogModule.psm1

$st = "Start deploy:" + (Get-Date)
LogModule($st)

# rg and location
$rgName = "Rg-iac-0001"
$location  = "uk south"

# deployment id
$tempId = New-Guid
$deploymentId = $tempId.ToString()
Write-Host $deploymentId
LogModule($deploymentId)

# deploy rg
New-AzResourceGroup -Name $rgName  -Location $location -Tag @{Infrastructure="IAC"} -Force

# deploy resources
$deployResult = New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentId -TemplateFile templates\main.bicep # -WhatIf

Write-Host $deployResult.ProvisioningState
$end = "End deploy:" + ($deployResult.ProvisioningState)
LogModule($end)



