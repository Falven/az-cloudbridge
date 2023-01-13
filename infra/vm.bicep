@description('Project name used in creation of VM name.')
param projectName string

@description('Environment name used in creation of VM name.')
param environment string

@description('Location of VM.')
param location string = resourceGroup().location

@description('The size of the VM.')
param vmSize string = 'Standard_B1ls'

@description('The OS Disk Type of the VM.')
param osDiskType string = 'Standard_LRS'

@description('The OS Disk Delete Option of the VM.')
param osDiskDeleteOption string = 'Delete'

@description('The NIC Delete Option for the VM.')
param osImage object = {
  publisher: 'Canonical'
  offer: '0001-com-ubuntu-server-jammy'
  sku: '22_04-lts-gen2'
  version: 'latest'
}

@description('The Id for the NIC of the VM.')
param nicId string

@description('The OS Disk Delete Option of the VM.')
param nicDeleteOption string = 'Detach'

@description('The Admins username of the VM.')
param adminUsername string = 'azureuser'

@secure()
@description('The Admin Password of the VM.')
param adminPassword string

@description('The Zones of the VM.')
param zones array = [ '1' ]

var vmName = 'vm-${projectName}-${environment}-${location}-001'

resource vm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
        deleteOption: osDiskDeleteOption
      }
      imageReference: osImage
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicId
          properties: {
            deleteOption: nicDeleteOption
          }
        }
      ]
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: true
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
  zones: zones
}
