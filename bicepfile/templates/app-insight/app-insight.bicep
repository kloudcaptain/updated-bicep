// Template to create Application Insight

// Template Parameters
param location string

param applicationInsightsName string

param logAnalyticsWorkspaceID string

// Resources
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceID
    Flow_Type: 'Bluefield'
  }
}

output applicationInsightsID string = applicationInsights.id
