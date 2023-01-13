@description('Project name used in creation of VNET name.')
param projectName string

@description('Environment name used in creation of VNET name.')
param environment string

@description('Location of VNET.')
param location string = resourceGroup().location

@description('Virtual Network Gateway Name.')
param vngName string

@description('Local Network Gateway Name.')
param lngName string

@secure()
@description('Connection Key.')
param key string

resource vng 'Microsoft.Network/virtualNetworkGateways@2022-07-01' existing = {
  name: vngName
  scope: resourceGroup()
}

resource lng 'Microsoft.Network/localNetworkGateways@2022-07-01' existing = {
  name: lngName
  scope: resourceGroup()
}

resource vco 'Microsoft.Network/connections@2022-07-01' = {
  name: 'vng-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    connectionType: 'IPsec'
    virtualNetworkGateway1: vng
    localNetworkGateway2: lng
    sharedKey: key
    dpdTimeoutSeconds: 45
  }
}
