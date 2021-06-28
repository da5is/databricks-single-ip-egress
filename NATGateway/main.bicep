param dbrgname string = 'rg-databricks'
param location string = 'eastus'
param vnetname string = 'vnet-databricks'
param vnetaddress string = '10.0.0.0/16'
param privsubnet string = 'subnet-priv'
param pubsubnet string = 'subnet-pub'
param publicsubnetaddress string = '10.0.1.0/24'
param privatesubnetaddress string = '10.0.2.0/24'
param dbmanagedrgname string = 'rg-databricks-managed'
param databricksname string = 'matdavidatabricks'
param sub string = subscription().id
param natgatewayname string = 'matdavinatgw'

targetScope = 'subscription'
// create databricks resourcegroup
resource rgdatabricks 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: dbrgname
  location: location
}
// create databricks vnet and firewall subnet
module createnetwork './createnetwork.bicep' = {
  name: 'createnetwork'
  scope: rgdatabricks
  params: {
    vnetname: vnetname
    vnetaddress: vnetaddress
  }
}

module createsubnets './createsubnets.bicep' = {
  name: 'createsubnets'
  scope: rgdatabricks
  params: {
    vnetname: vnetname
    privsubnet: privsubnet
    pubsubnet: pubsubnet
    privatesubnetaddress: privatesubnetaddress
    publicsubnetaddress: publicsubnetaddress
    natgatwayname: natgatewayname
  }
}

module createdatabricks './createdatabricks.bicep' = {
  name: 'createdatabricks'
  scope: rgdatabricks
  dependsOn: [
    createsubnets
  ]
  params: {
    managedrgid: '${sub}/resourceGroups/${dbmanagedrgname}'
    databricksname: databricksname
    privsubnet: privsubnet
    pubsubnet: pubsubnet
    vnetid: createnetwork.outputs.vnetid
  }
}
