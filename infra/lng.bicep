@description('Project name used in creation of VNET name.')
param projectName string

@description('Environment name used in creation of VNET name.')
param environment string

@description('Location of VNET.')
param location string = resourceGroup().location

@description('Connection Fully Qualified Domain Name.')
param fqdn string

@description('Connection Key.')
param addressPrefixes array = [ '192.168.1.0/24' ]

resource lng 'Microsoft.Network/localNetworkGateways@2022-07-01' = {
  name: 'lng-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    fqdn: fqdn
    localNetworkAddressSpace: {
      addressPrefixes: addressPrefixes
    }
  }
}

output name string = lng.name
