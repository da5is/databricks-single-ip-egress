targetScope = 'resourceGroup'
param fwipaddress string 
param publicsubnetaddress string

resource routetable 'Microsoft.Network/routeTables@2021-02-01' = {
  name: 'internet-route-table'
  location: resourceGroup().location
  properties: {
    routes: [
      {
        name: 'databricks-to-nva'
        properties: {
          addressPrefix: publicsubnetaddress
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: fwipaddress 
        }
      }
    ]
  }
}
output routetableid string = routetable.id
