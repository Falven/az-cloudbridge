@description('Project name used in creation of VNET name.')
param projectName string

@description('Environment name used in creation of VNET name.')
param environment string

@description('Location of VNET.')
param location string = resourceGroup().location

@description('Virtual Network Resource Id.')
param vngId string

@description('Local Network Resource Id.')
param lngId string

@secure()
@description('Connection Key.')
param key string

resource vco 'Microsoft.Network/connections@2022-07-01' = {
  name: 'vng-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    connectionType: 'IPsec'
    virtualNetworkGateway1: {
      id: vngId
      properties: {}
    }
    localNetworkGateway2: {
      id: lngId
      properties: {}
    }
    sharedKey: key
    dpdTimeoutSeconds: 45
  }
}
