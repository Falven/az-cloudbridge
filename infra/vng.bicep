@description('Project name used in creation of VNET name.')
param projectName string

@description('Environment name used in creation of VNET name.')
param environment string

@description('Location of VNET.')
param location string = resourceGroup().location

@description('Resource Id of the Subnet.')
param snetId string

@description('Resource Id of the Public IP Address.')
param pipId string

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
            id: snetId
          }
          publicIPAddress: {
            id: pipId
          }
        }
      }
    ]
  }
}

output name string = vng.name
