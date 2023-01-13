@description('Name used in creation of NSG name.')
param projectName string

@description('Environment name used in creation of NSG name.')
param environment string

@description('Location of NSG.')
param location string = resourceGroup().location

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

output id string = resourceId('Microsoft.Network/networkSecurityGroups', nsg.name)
