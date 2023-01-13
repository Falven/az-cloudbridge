@description('Name used in creation of NIC name.')
param projectName string

@description('Environment name used in creation of NIC name.')
param environment string

@description('Location of NIC.')
param location string = resourceGroup().location

@description('Subnet Id')
param subnetId string

@description('Public Ip Id.')
param pipId string

@description('Whether to delete the PIP on deletion of this nic.')
param pipDeleteOption string = 'Delete'

@description('NSG Id.')
param nsgId string

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'nic-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pipId
            properties: {
              deleteOption: pipDeleteOption
            }
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

output id string = resourceId('Microsoft.Network/networkInterfaces', nic.name)
