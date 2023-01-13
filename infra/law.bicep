@description('Project name used in creation of Log Analytics Workspace name.')
param projectName string

@description('Environment name used in creation of Log Analytics Workspace name.')
param environment string

@description('Location of Log Analytics Workspace.')
param location string

resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'log-${projectName}-${environment}-${location}-001'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}
