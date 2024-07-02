// Template to create App Service plan

// Template Parameters
param sku string

param location string

param appServicePlanName string

param planOS string

// Resources
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
  }
  kind: planOS
  properties: {
    reserved: true
  }
}

output appServicePlanID string = appServicePlan.id
