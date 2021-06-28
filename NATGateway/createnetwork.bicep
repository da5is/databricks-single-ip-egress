targetScope = 'resourceGroup'
param vnetname string
param vnetaddress string

resource databricksnetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetname
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetaddress
      ]
    }
  }
}
output vnetid string = databricksnetwork.id
