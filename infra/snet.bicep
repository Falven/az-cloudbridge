@description('Project name used in creation of SNET name.')
param projectName string

@description('Environment name used in creation of SNET name.')
param environment string

@description('Location of SNET.')
param location string = resourceGroup().location

@description('Subnet Address Space (CIDR notation, /23 or greater)')
param subnetAddressSpace string = '10.0.0.0/23'

resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: 'snet-${projectName}-${environment}-${location}-001'
  properties: {
    addressPrefix: subnetAddressSpace
  }
}

output name string = snet.name
