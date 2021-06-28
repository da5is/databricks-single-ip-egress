targetScope = 'resourceGroup'
param vnetid string
param publicsubnet string

resource azfwpip 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'pip-dbazfw'
  location: resourceGroup().location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
}

resource azfwpolicy 'Microsoft.Network/firewallPolicies@2021-02-01' = {
  name: 'pol-azfwdb'
  location: resourceGroup().location
  properties: {}
}

resource firewallinternetpolicy 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  parent: azfwpolicy
  name: 'network-policy-rule-collection'
  properties: {
    priority: 200
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'dbpublic'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              publicsubnet
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '0.0.0.0/1'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '*'
            ]
          }
        ]
        name: 'rule-publicnet-to-internet'
        priority: 200
      }
    ]
  }
}

resource azfw 'Microsoft.Network/azureFirewalls@2021-02-01' = {
  name: 'dbazfw'
  location: 'eastus'
  dependsOn: [
    azfwpip
    azfwpolicy
  ]
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
    additionalProperties: {}
    ipConfigurations: [
      {
        name: 'azfwpip'
        properties: {
          publicIPAddress: {
            id: azfwpip.id
          }
          subnet: {
            id: '${vnetid}/subnets/AzureFirewallSubnet'
          }
        }
      }
    ]
    networkRuleCollections: []
    applicationRuleCollections: []
    natRuleCollections: []
    firewallPolicy: {
      id: azfwpolicy.id
    }
  }
}

output fwipaddress string = azfw.properties.ipConfigurations[0].properties.privateIPAddress
