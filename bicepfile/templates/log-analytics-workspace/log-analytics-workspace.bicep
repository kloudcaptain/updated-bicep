// Template to create Log Analytics Workspcae

// Template Parameters
param location string

param logAnalyticsWorkspaceName string 

// Resources
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Disabled'
  }
}

output logAnalyticsWorkspaceID string = logAnalyticsWorkspace.id

