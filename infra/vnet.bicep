@description('Project name used in creation of VNET name.')
param projectName string

@description('Environment name used in creation of VNET name.')
param environment string

@description('Location of VNET.')
param location string = resourceGroup().location

@description('VNET Address Space (CIDR notation, /23 or greater)')
param addressSpace string = '10.0.0.0/16'

@description('Subnet resource name')
param containerAppSubnetName string = 'snet-${projectName}-${environment}-${location}-001'

@description('Subnet Address Space (CIDR notation, /23 or greater)')
param subnetAddressSpace string = '10.0.0.0/23'

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: 'vnet-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [ addressSpace ]
    }
  }

  resource snet 'subnets@2022-07-01' = {
    name: containerAppSubnetName
    properties: {
      addressPrefix: subnetAddressSpace
    }
  }
}

output snetName string = vnet::snet.name
