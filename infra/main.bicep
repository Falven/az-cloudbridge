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

module snet 'snet.bicep' = {
  name: 'snet-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
  }
}

module vnet 'vnet.bicep' = {
  name: 'vnet-deployment'
  params: {
    projectName: projectName
    environment: environment
    location: location
    snetName: snet.outputs.name
  }
  dependsOn: [ snet ]
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
    snetName: snet.outputs.name
    pipName: pip.outputs.name
  }
  dependsOn: [ pip ]
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
    vnetName: vnet.outputs.name
    snetName: snet.outputs.name
    lawName: law.outputs.name
  }
  dependsOn: [ vnet, law ]
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
  dependsOn: [ ame ]
}
