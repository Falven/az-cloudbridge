@description('Project name used in creation of VNET name.')
param projectName string

@description('Environment name used in creation of VNET name.')
param environment string

@description('Location of VNET.')
param location string = resourceGroup().location

@description('Name of the Subnet.')
param snetName string

@description('Name of the Public IP Address.')
param pipName string

resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: snetName
  scope: resourceGroup()
}

resource pip 'Microsoft.Network/publicIPAddresses@2022-07-01' existing = {
  name: pipName
  scope: resourceGroup()
}

resource vng 'Microsoft.Network/virtualNetworkGateways@2022-07-01' = {
  name: 'vng-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
    vpnGatewayGeneration: 'Generation1'
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: snet.name
          }
          publicIPAddress: {
            id: pip.id
          }
        }
      }
    ]
  }
}

output name string = vng.name
