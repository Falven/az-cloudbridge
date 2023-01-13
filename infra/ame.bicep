@description('Project name used in creation of Managed Environment name.')
param projectName string

@description('Environment name used in creation of Managed Environment name.')
param environment string

@description('Location of Managed Environment.')
param location string

@description('Name of VNET.')
param vnetName string

@description('Name of Subnet.')
param snetName string

@description('Name of Log Analytics Workspace.')
param lawName string

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetName
  scope: resourceGroup()

  resource subnet 'subnets@2022-07-01' existing = {
    name: snetName
  }
}

resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: lawName
  scope: resourceGroup()
}

resource ame 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
  name: 'cae-${projectName}-${environment}-${location}-001'
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
      infrastructureSubnetId: vnet::subnet.id
    }
  }
}

output id string = ame.id
