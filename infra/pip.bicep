@description('Project name used in creation of VNET name.')
param projectName string

@description('Environment name used in creation of VNET name.')
param environment string

@description('Location of VNET.')
param location string = resourceGroup().location

resource pip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: 'pip-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

output id string = resourceId('Microsoft.Network/publicIPAddresses', pip.name)
