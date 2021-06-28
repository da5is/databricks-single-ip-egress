targetScope = 'resourceGroup'
param managedrgid string
param databricksname string
param privsubnet string
param pubsubnet string
param vnetid string

resource dbcluster 'Microsoft.Databricks/workspaces@2018-04-01' = {
  name: databricksname
  location: resourceGroup().location
  properties: {
    managedResourceGroupId: managedrgid 
    parameters: {
      customPrivateSubnetName: { 
        value: privsubnet 
      }
      customPublicSubnetName: { 
        value: pubsubnet
      }
      customVirtualNetworkId: {
        value: vnetid
      }
    }
  }
}
