# Azure Automation

## Preface

1. azure-arm-104 https://github.com/spawnmarvel/azure-arm-104
2. Azure Administrator Cheat Sheet https://github.com/spawnmarvel/quickguides/tree/main/azure
3. Azure Administrator Cheat Sheet quick guide https://github.com/spawnmarvel/quickguides/tree/main/azure/quick-guide

##  Azure Automation as Microsoft Certified: Azure Administrator Associate

According to Microsoft https://learn.microsoft.com/en-us/certifications/azure-administrator/

* Candidates for the Azure Administrator Associate certification should have subject matter expertise in implementing, managing, and monitoring an organization’s Microsoft Azure environment, including virtual networks, storage, compute, identity, security, and governance.

* An Azure administrator often serves as part of a larger team dedicated to implementing an organization's cloud infrastructure. 

* Azure administrators also coordinate with other roles to deliver Azure networking, security, database, application development, and DevOps solutions.

* Candidates for this certification should be familiar with operating systems, networking, servers, and virtualization. In addition, professionals in this role should have experience using PowerShell, Azure CLI, the Azure portal, Azure Resource Manager templates (ARM templates), and Microsoft Azure Active Directory (Azure AD), part of Microsoft Entra.

## Microsoft Certified: Azure Administrator Associate

Yea, finally passed AZ 104 Microsoft Azure Administrator and earned the title Microsoft Certified: Azure Administrator Associate.

What now.....

### Focus on

1. Compute. 

   * The Azure Administrator is most often identified with infrastructure-as-a-service (IaaS), which normally boils down to running virtual machines (VMs) in the cloud.
   * Containers represent a newer way to virtualize services, and Docker is extremely well-represented in Azure.

2. Storage

   * Azure provides Administrators with essentially limitless storage. You need space to store VM virtual hard disks (VHDs), database files, application data, and potentially user data.
   * Cloud computing’s shared responsibility model.
   * Securing data against unauthorized access.
   * Backing up data and making it efficient to restore when needed.

3. Network

   * Deploying and configuring virtual networks
   * Managing public and private IP addresses for your VMs and selected other Azure resources

4. Security

   * The security stakes are high in the Azure public cloud because your business stores its proprietary data on someone else’s infrastructure.
   * Encrypting data in transit, at rest, and in use.
   * Protecting Azure Active Directory accounts against compromise
   * Reducing the attack surface of all your Azure resources

5. Monitor

   * Azure Monitor Insights overview
   * https://learn.microsoft.com/en-us/azure/azure-monitor/insights/insights-overview
   * Application insight
   * Container insight
   * VM insights
   * Network insights


6. Bone up on your PowerShell and JavaScript Object Notation, (ARM and BICEP).

   * Unlike most of the Azure training and labs, relatively-little day-to-day work takes place within the web console.


## Automating Azure (glasspaper 2023 Paul "Dash" Wojcicki-Jarocki)

Make our life easier in Azure. Explorer Powershell and where it fits in, main topic is Automation accounts.

1. Azure Portal, check out stuff in preview.

![Preview things ](https://github.com/spawnmarvel/azure-automation/blob/main/images/preview.jpg)

2. Cloud shell (a bit buggy but ok), store scripts and files in the fileshare.
*  Disable Predictive Intellisens and Save autentication token (could need it later)
```
PS /home/espen/clouddrive> code $PROFILE.CurrentUserAllHosts

# Edit the profile.ps1
# profile.ps1 for use in Azure Cloud Shell

# Disable Predictive Intellisens
Set-PSReadLineOption -PredictiveSource None -BellStyle Visual

# Save autentication token
$AUTH = Invoke-RestMethod -Uri "env:MSI_ENDPOINT`?resource=https://management.core.windows.net/" -Headers @{Metadata = 'true'}
```

Shell and files

![Cloud shell ](https://github.com/spawnmarvel/azure-automation/blob/main/images/cloudshell.jpg)

3. Scripts, ARM templates, Bicep
* ARM templates
* https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview

* Some limitiations of scripts:
* * Many collaborators and different styles
* * Have to have the correct modules (have to keep track of versions etc)
* * Current modules starts with Az: Get-AzContext | Select-Object Account, Name
* * Template JSON files, template and parameter.json
```

# parameters.json

{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "customName": {
            "value": "testtutorial"
        },
        "storageSKU": {
            "value": "Standard_LRS"
          },
        "location": {
            "value": "westeurope"
        },
        "resourceTags": {
            "value": {
              "Environment": "Test",
              "Project": "Tutorial"
            }
          }
        
    }
}

# template.json (Not complete file just for logic)

    // your api reference
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    // your version
    "contentVersion": "1.0.0.0",
    "parameters": {

        "customName": {
            // a custom paramter
            "type": "string",
            "metadata" :{
                "description": "a description"
            }
        },

         "location": {
            "type": "string",
            // a function call
            "defaultValue": "[resourceGroup().location]",

    "variables": {
        // a var
        "customNameUnique": "[concat(parameters('customName'),uniqueString(resourceGroup().id))]"

    "functions": [],
    "resources": [
        // 1 resource
        {
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2021-04-01",
            // var used
            "name": "[variables('customNameUnique')]",
            "location": "[parameters('location')]",
            "tags": "[parameters('resourceTags')]",

            "dependsOn": [],

            "sku": {
                "name": "[parameters('storageSKU')]"
            },

            "kind": "StorageV2",

    "outputs": {
        //
            "storageEndpoint": {
                "type": "object",
                "value": "[reference(variables('customNameUnique')).primaryEndpoints]"
            }
        //


```

The newer version of this is Bicep
* Another txt file.bicep with simpler syntax, more readble.
* MS is investing much in this 2023.
* Bicep gets translated to json ARM.

```
# https://learn.microsoft.com/en-us/powershell/module/az.resources/new-azresourcegroupdeployment?view=azps-9.6.0

New-AzResourceGroupDeployment
   [-Name <String>]
   -ResourceGroupName <String>
   [-Mode <DeploymentMode>]
   [-DeploymentDebugLogLevel <String>]
   [-RollbackToLastDeployment]
   [-RollBackDeploymentName <String>]
   [-Tag <Hashtable>]
   [-WhatIfResultFormat <WhatIfResultFormat>]
   [-WhatIfExcludeChangeType <String[]>]
   [-Force]
   [-ProceedIfNoChange]
   [-AsJob]
   [-QueryString <String>]
   -TemplateFile <String>
   [-SkipTemplateParameterPrompt]
   [-Pre]
   [-DefaultProfile <IAzureContextContainer>]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]


```

3. Template specs
* A template spec is a resource type for storing an Azure Resource Manager template (ARM template) in Azure for later deployment. 
* This resource type enables you to share ARM templates with other users in your organization.
* https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs?tabs=azure-powershell

4. Blueprints

5. Automation runbooks and

6. Azure functions

7. Low code option


## Azure PowerShell Documentation

https://learn.microsoft.com/en-us/powershell/azure/?view=azps-9.6.0



