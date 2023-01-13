@description('Project name used in creation of services.')
param projectName string

@description('Environment name used in creation of services.')
param environment string

@description('Location of services.')
param location string = resourceGroup().location

@description('Name of the container registry.')
param registryName string

@description('Name of the container image.')
param containerImage string

@description('VPN Fully Qualified Domain Name.')
param vpnFQDN string

@secure()
@description('VPN Key.')
param vpnKey string

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
    snetId: vnet.outputs.snetId
    pipId: pip.outputs.id
  }
}

module vco 'vco.bicep' = {
  name: 'vco-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
    vngName: vng.outputs.name
    fqdn: vpnFQDN
    key: vpnKey
  }
}

module law 'law.bicep' = {
  name: 'law-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
  }
}

module ame 'ame.bicep' = {
  name: 'ame-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
    snetId: vnet.outputs.snetId
    lawName: law.outputs.name
  }
}

module aca 'aca.bicep' = {
  name: 'aca-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
    managedEnvironmentId: ame.outputs.id
    registryName: registryName
    containerImage: containerImage
    command: [ '--net=host', '--name=homebridge', '-v', '$(pwd)/homebridge:/homebridge' ]
  }
}
