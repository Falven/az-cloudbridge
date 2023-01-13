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

@description('The reference to the VirtualNetworkGatewaySku resource which represents the SKU selected for Virtual network gateway.')
param sku object = {
  name: 'Basic'
  tier: 'Basic'
}

resource vng 'Microsoft.Network/virtualNetworkGateways@2022-07-01' = {
  name: 'vng-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    sku: sku
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

output id string = resourceId('Microsoft.Network/virtualNetworkGateways', vng.name)
