targetScope = 'resourceGroup'
param vnetname string
param privsubnet string
param pubsubnet string
param privatesubnetaddress string
param publicsubnetaddress string
param routetableid string

resource respubsub 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name: '${vnetname}/${pubsubnet}'
  dependsOn: [
    nsgpub
  ]
  properties: {
    addressPrefix: publicsubnetaddress
    routeTable: {
      id: routetableid
    }
    serviceEndpoints: [
      {
        service: 'microsoft.storage'
      }
      {
        service: 'microsoft.sql'
      }
    ]
    networkSecurityGroup: {
      id: nsgpub.id
    }
    delegations: [
      {
        name: 'Microsoft.Databricks/workspaces'
        properties: {
          serviceName: 'Microsoft.Databricks/workspaces'
        }
      }
    ]
  }
}
resource nsgpub 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'nsg_public_subnet'
  location: resourceGroup().location
  properties: {
    securityRules: []
  }
}

resource resprivsub 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name: '${vnetname}/${privsubnet}'
  dependsOn: [
    nsgpriv
    respubsub
  ]
  properties: {
    addressPrefix: privatesubnetaddress
    networkSecurityGroup: {
      id: nsgpriv.id
    }
    delegations: [
      {
        name: 'Microsoft.Databricks/workspaces'
        properties: {
          serviceName: 'Microsoft.Databricks/workspaces'
        }
      }
    ]
  }
}

resource nsgpriv 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'nsg_private_subnet'
  location: resourceGroup().location
  properties: {
    securityRules: []
  }
}
