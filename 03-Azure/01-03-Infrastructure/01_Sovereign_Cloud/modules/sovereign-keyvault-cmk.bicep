// MODULE: sovereign-keyvault-cmk
// PURPOSE: Key Vault configured for Customer Managed Key scenarios with
//          purge protection, soft delete, private endpoint, and diagnostic settings.
// SOURCE: REUSE_CATALOG items tagged Encryption and Key Management
//         - solution-02.md (EXTRACT PATTERN)
//         - solution-04.md (EXTRACT PATTERN)
//         - BCDR keyvault.bicep (ADAPT AND PARAMETERIZE)

targetScope = 'resourceGroup'

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------

@description('Name of the Key Vault (must be globally unique, 3-24 alphanumeric characters)')
@minLength(3)
@maxLength(24)
param keyVaultName string

@description('Azure region for the Key Vault; should match sovereign region requirements')
param location string = resourceGroup().location

@description('Key Vault SKU')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'premium'

@description('Enable purge protection to prevent permanent key deletion')
param enablePurgeProtection bool = true

@description('Soft-delete retention period in days (7-90)')
@minValue(7)
@maxValue(90)
param softDeleteRetentionInDays int = 90

@description('Enable RBAC authorization model instead of access policies')
param enableRbacAuthorization bool = true

@description('Enable Key Vault for ARM template deployments')
param enabledForTemplateDeployment bool = true

@description('Enable Key Vault for Azure Disk Encryption')
param enabledForDiskEncryption bool = false

@description('Enable Key Vault for VM deployment (secret retrieval)')
param enabledForDeployment bool = true

@description('Subnet resource ID for the private endpoint')
param privateEndpointSubnetId string = ''

@description('Log Analytics workspace resource ID for diagnostic settings')
param logAnalyticsWorkspaceId string = ''

@description('Tags to apply to all resources')
param tags object = {}

// ---------------------------------------------------------------------------
// Resources
// ---------------------------------------------------------------------------

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: skuName
    }
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enablePurgeProtection: enablePurgeProtection
    enableRbacAuthorization: enableRbacAuthorization
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForDeployment: enabledForDeployment
    accessPolicies: []
    networkAcls: {
      defaultAction: (privateEndpointSubnetId != '') ? 'Deny' : 'Allow'
      bypass: 'AzureServices'
    }
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-01-01' = if (privateEndpointSubnetId != '') {
  name: '${keyVaultName}-pe'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${keyVaultName}-plsc'
        properties: {
          privateLinkServiceId: keyVault.id
          groupIds: [
            'vault'
          ]
        }
      }
    ]
  }
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (logAnalyticsWorkspaceId != '') {
  name: '${keyVaultName}-diag'
  scope: keyVault
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

output keyVaultId string = keyVault.id
output keyVaultUri string = keyVault.properties.vaultUri
output keyVaultName string = keyVault.name
output privateEndpointId string = (privateEndpointSubnetId != '') ? privateEndpoint.id : ''
