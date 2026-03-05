// MODULE: sovereign-tls-enforcement
// PURPOSE: Azure Policy assignment and diagnostic settings to enforce TLS
//          minimum version across Storage, SQL, and App Service.
// SOURCE: REUSE_CATALOG items tagged Encryption and Key Management
//         - solution-03.md (EXTRACT PATTERN)
//         - sovereign-cloud-initiative.json

targetScope = 'subscription'

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------

@description('Minimum TLS version to enforce')
@allowed([
  'TLS1_2'
  'TLS1_3'
])
param minimumTlsVersion string = 'TLS1_2'

@description('Policy effect for Storage TLS enforcement')
@allowed([
  'Audit'
  'Deny'
  'Disabled'
])
param storageEffect string = 'Deny'

@description('Policy effect for SQL TLS enforcement')
@allowed([
  'Audit'
  'Disabled'
])
param sqlEffect string = 'Audit'

@description('Policy effect for App Service TLS enforcement')
@allowed([
  'AuditIfNotExists'
  'Disabled'
])
param appServiceEffect string = 'AuditIfNotExists'

@description('Enforcement mode for the policy assignments')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'

// ---------------------------------------------------------------------------
// Resources
// ---------------------------------------------------------------------------

// Storage accounts: enforce minimum TLS version (fe83a0eb-a853-422d-aac2-1bffd182c5d0)
resource storageTlsPolicy 'Microsoft.Authorization/policyAssignments@2024-05-01' = {
  name: 'enforce-storage-min-tls'
  properties: {
    displayName: 'Enforce Storage minimum TLS ${minimumTlsVersion}'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/fe83a0eb-a853-422d-aac2-1bffd182c5d0'
    enforcementMode: enforcementMode
    parameters: {
      effect: {
        value: storageEffect
      }
      minimumTlsVersion: {
        value: minimumTlsVersion
      }
    }
  }
}

// SQL Servers: enforce minimum TLS version (32e6bbec-16b6-44c2-be37-c5b672d103cf)
resource sqlTlsPolicy 'Microsoft.Authorization/policyAssignments@2024-05-01' = {
  name: 'enforce-sql-min-tls'
  properties: {
    displayName: 'Enforce SQL Server minimum TLS ${minimumTlsVersion}'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/32e6bbec-16b6-44c2-be37-c5b672d103cf'
    enforcementMode: enforcementMode
    parameters: {
      effect: {
        value: sqlEffect
      }
    }
  }
}

// App Service: enforce latest TLS version (f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b)
resource appServiceTlsPolicy 'Microsoft.Authorization/policyAssignments@2024-05-01' = {
  name: 'enforce-appservice-min-tls'
  properties: {
    displayName: 'Enforce App Service latest TLS version'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b'
    enforcementMode: enforcementMode
    parameters: {
      effect: {
        value: appServiceEffect
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

output storagePolicyAssignmentId string = storageTlsPolicy.id
output sqlPolicyAssignmentId string = sqlTlsPolicy.id
output appServicePolicyAssignmentId string = appServiceTlsPolicy.id
