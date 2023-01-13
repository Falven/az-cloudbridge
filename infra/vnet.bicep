@description('Project name used in creation of VNET name.')
param projectName string

@description('Environment name used in creation of VNET name.')
param environment string

@description('Location of VNET.')
param location string = resourceGroup().location

@description('VNET Address Space (CIDR notation, /23 or greater)')
param addressSpace string = '10.0.0.0/16'

@description('Name of the SNET')
param snetName string

resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: snetName
  scope: resourceGroup()
}

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: 'vnet-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [ addressSpace ]
    }
    subnets: [
      snet
    ]
  }
}

output name string = vnet.name
