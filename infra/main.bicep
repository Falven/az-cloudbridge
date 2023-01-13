@description('Project name used in creation of services.')
param projectName string

@description('Environment name used in creation of services.')
param environment string

@description('Location of services.')
param location string = resourceGroup().location

@description('VPN Fully Qualified Domain Name.')
param vpnFQDN string

@secure()
@description('VPN Key.')
param vpnKey string

@description('The Admin username of the VM.')
param adminUsername string = 'azureuser'

@secure()
@description('The Admin Password of the VM.')
param adminPassword string

module vnet 'vnet.bicep' = {
  name: 'vnet-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
  }
}

module pip 'pip.bicep' = {
  name: 'pip-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
  }
}

module vng 'vng.bicep' = {
  name: 'vng-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
    snetId: vnet.outputs.gatewaySnetId
    pipId: pip.outputs.id
    sku: {
      name: 'basic'
      sku: 'VpnGw1AZ'
    }
  }
}

module lng 'lng.bicep' = {
  name: 'lng-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
    fqdn: vpnFQDN
  }
}

module vco 'vco.bicep' = {
  name: 'vco-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
    vngId: vng.outputs.id
    lngId: lng.outputs.id
    key: vpnKey
  }
}

module nsg 'nsg.bicep' = {
  name: 'nsg-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
  }
}

module nic 'nic.bicep' = {
  name: 'nic-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
    nsgId: nsg.outputs.id
    pipId: pip.outputs.id
    subnetId: vnet.outputs.defaultSnetId
  }
}

module vm 'vm.bicep' = {
  name: 'vm-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
    nicId: nic.outputs.id
  }
}
