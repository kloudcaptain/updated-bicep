// Template Parameters
@description('Resources Location')
param location string = resourceGroup().location

@description('Storage Account type')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param storageAccountType string

@description('The name of the storage account')
param storageAccountName string

@description('Log Analytics resource name')
param logAnalyticsWorkspaceName string

@description('Application Insights resource name')
param applicationInsightsName string

@description('The SKU of App Service Plan ')
param skuPlan string

@description('App Service Plan Name')
param appServicePlanName string

@description('App Service Plan Name')
param planOS string

@description('Web App name.')
@minLength(2)
param webAppName string

@description('The Runtime stack of current web app')
param linuxFxVersion string

@description('The name of the Azure Function app.')
param functionAppName string

@description('Storage Account name')
param functionStrName string

@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param functionStrAccType string

@description('The language worker runtime to load in the function app.')
param functionWorkerRuntime string


module storageAccount './templates/storage-account/storage-account.bicep' = {
  name: 'storageAccount'
  params: {
    storageAccountType : storageAccountType
    location : location
    storageAccountName : storageAccountName
  }
}

module logAnalyticsWorkspace 'templates/log-analytics-workspace/log-analytics-workspace.bicep' = {
  name: 'logAnalyticsWorkspace'
  params: {
    location : location
    logAnalyticsWorkspaceName : logAnalyticsWorkspaceName
  }
}

module appInsight 'templates/app-insight/app-insight.bicep' = {
  name: 'appInsight'
  params: {
      location : location
      applicationInsightsName : applicationInsightsName
      logAnalyticsWorkspaceID : logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceID
  }
  dependsOn: [
    logAnalyticsWorkspace
  ]
}

module appServicePlan 'templates/app-service-plan/app-service-plan.bicep' = {
  name: 'appServicePlan'
  params: {
    sku : skuPlan
    location : location
    planOS: planOS
    appServicePlanName : appServicePlanName
  }
}

module webApp 'templates/web-app/web-app.bicep' = {
  name: 'webApp'
  params: {
    appServicePlanID : appServicePlan.outputs.appServicePlanID
    webAppName : webAppName
    location : location
    linuxFxVersion : linuxFxVersion
    applicationInsightsID : appInsight.outputs.applicationInsightsID
  }
  dependsOn: [
    appServicePlan
    appInsight
  ]
}

module functionApp  'templates/function-app/function-app.bicep' = {
  name: 'functionApp'
  params: {
    appServicePlanID : appServicePlan.outputs.appServicePlanID
    functionAppName : functionAppName
    functionStrAccType : functionStrAccType
    functionStrName: functionStrName
    location : location
    functionWorkerRuntime : functionWorkerRuntime
    applicationInsightsID : appInsight.outputs.applicationInsightsID
  }
  dependsOn: [
    appServicePlan
    appInsight
]
}



