@description('Project name used in creation of Managed Environment name.')
param projectName string

@description('Environment name used in creation of Managed Environment name.')
param environment string

@description('Location of Managed Environment.')
param location string

@description('Resource Id of the Subnet.')
param snetId string

@description('Name of the Log Analytics Workspace.')
param lawName string

resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: lawName
  scope: resourceGroup()
}

resource ame 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
  name: 'ame-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: law.properties.customerId
        sharedKey: law.listKeys().primarySharedKey
      }
    }
    vnetConfiguration: {
      infrastructureSubnetId: snetId
    }
  }
}

output id string = ame.id
