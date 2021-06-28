targetScope = 'resourceGroup'
param vnetname string
param vnetaddress string
param firewallsubnetaddress string

resource databricksnetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetname
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetaddress
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: firewallsubnetaddress
        }
      }
    ]
  }
}
output vnetid string = databricksnetwork.id
