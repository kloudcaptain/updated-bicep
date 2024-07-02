// Template to create webapp

// Template Parameters
param webAppName string

param location string

param linuxFxVersion string

param appServicePlanID string

param applicationInsightsID string

param slotsName array = [
  'staging'
  'qa'
  'uat'
]

// Resources
resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: webAppName
  location: location
  properties: {
    httpsOnly: true
    serverFarmId: appServicePlanID
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference(applicationInsightsID, '2015-05-01').InstrumentationKey
        }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource stagingSlot 'Microsoft.Web/sites/slots@2021-02-01' = [for name in slotsName: {
  name: '${name}'
  parent: webApp
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanID
  }
}]
