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
      {
        name: 'webapp1-to-internet'
        properties: {
          addressPrefix: '40.70.58.221/32'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'webapp2-to-internet'
        properties: {
          addressPrefix: '20.42.4.209/32'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'webapp3-to-internet'
        properties: {
          addressPrefix: '20.42.4.211/32'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'controlplanenat1-to-internet'
        properties: {
          addressPrefix: '23.101.152.95/32'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'controlplanenat2-to-internet'
        properties: {
          addressPrefix: '20.42.4.208/32'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'controlplanenat3-to-internet'
        properties: {
          addressPrefix: '20.42.4.210/32'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'extendedinfra-to-internet'
        properties: {
          addressPrefix: '20.57.106.0/28'
          nextHopType: 'Internet'
        }
      }
    ]
  }
}
output routetableid string = routetable.id
