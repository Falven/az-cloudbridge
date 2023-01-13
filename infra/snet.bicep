@description('Project name used in creation of SNET name.')
param projectName string

@description('Environment name used in creation of SNET name.')
param environment string

@description('Location of SNET.')
param location string = resourceGroup().location

@description('VNET parent resource name used in creation of SNET name.')
param vnetName string

resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${vnetName}/snet-${projectName}-${environment}-${location}-002'
  properties: {
    addressPrefix: '10.0.0.0/23'
  }
}

output name string = snet.name
