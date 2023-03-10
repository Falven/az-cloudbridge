@description('Project name used in creation of VNET name.')
param projectName string

@description('Environment name used in creation of VNET name.')
param environment string

@description('Location of VNET.')
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: 'vnet-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [ '10.0.0.0/16' ]
    }
  }

  resource defaultSnet 'subnets@2022-07-01' = {
    name: 'default'
    properties: {
      // /23 is a requirement for ACA
      addressPrefix: '10.0.0.0/23'
    }
  }

  resource gatewaySnet 'subnets@2022-07-01' = {
    name: 'GatewaySubnet'
    properties: {
      addressPrefix: '10.0.2.0/24'
    }
    // Needed or Bicep tries to deploy the Subnets in parallel.
    // Error: Another operation on this or dependent resource is in progress.
    dependsOn: [ defaultSnet ]
  }
}

output defaultSnetId string = resourceId('Microsoft.Network/VirtualNetworks/subnets', vnet.name, vnet::defaultSnet.name)
output gatewaySnetId string = resourceId('Microsoft.Network/VirtualNetworks/subnets', vnet.name, vnet::gatewaySnet.name)
