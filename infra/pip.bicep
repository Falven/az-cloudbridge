@description('Project name used in creation of PIP name.')
param projectName string

@description('Environment name used in creation of PIP name.')
param environment string

@description('Location of PIP.')
param location string = resourceGroup().location

@description('The public IP address allocation method.')
param allocationMethod string = 'Static'

@description('IP SKU.')
param sku string = 'Standard'

@description('IP Zones.')
param zones array = [
  '1'
]

resource pip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: 'pip-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    publicIPAllocationMethod: allocationMethod
  }
  sku: {
    name: sku
  }
  zones: zones
}

output id string = resourceId('Microsoft.Network/publicIPAddresses', pip.name)
