@description('Project name used in creation of Azure Container App name.')
param projectName string

@description('Environment name used in creation of Azure Container App name.')
param environment string

@description('Location of Azure Container App.')
param location string

@description('ID of the Managed Environment.')
param managedEnvironmentId string

@description('Name of the container registry.')
param registryName string

@description('Name of the container image.')
param containerImage string

@description('Custom startup command.')
param command array = []

@description('Container AppSettings.')
param appSettings array = []

resource registry 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' existing = {
  name: registryName
  scope: resourceGroup()
}

resource containerApp 'Microsoft.App/containerApps@2022-01-01-preview' = {
  name: 'aca-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    managedEnvironmentId: managedEnvironmentId
    configuration: {
      secrets: [
        {
          name: 'registry-password'
          value: registry.listCredentials().passwords[0].value
        }
      ]
      registries: [
        {
          server: registry.properties.loginServer
          username: registry.listCredentials().username
          passwordSecretRef: 'registry-password'
        }
      ]
      ingress: {
        external: true
        targetPort: 80
      }
    }
    template: {
      containers: [
        {
          image: containerImage
          name: projectName
          env: appSettings
          command: command
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}
