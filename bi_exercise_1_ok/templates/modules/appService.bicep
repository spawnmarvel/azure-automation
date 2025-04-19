// https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/8-exercise-refactor-template-modules?pivots=powershell
param location string
param appServiceAppName string

@allowed([
  'nonprod'
  'prod'
])

param environmentType string

var appServicePlanName = 'toy-product-launch-plan'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3': 'F1'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name:appServicePlanName
  location:location
  sku:{
    name:appServicePlanSkuName
  }

}

resource appServiceApp 'Microsoft.Web/sites@2022-09-01' = {
  name:appServiceAppName
  location:location
  properties:{
    serverFarmId:appServicePlan.id
    httpsOnly:true
  }
}
output appServiceAppHostName string = appServiceApp.properties.defaultHostName
