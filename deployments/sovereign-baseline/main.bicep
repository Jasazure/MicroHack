// ORCHESTRATION: sovereign-baseline/main.bicep
// PURPOSE: Main deployment template for the Sovereign Cloud Platform Landing Zone.
//          Composes all seven sovereign modules into a single subscription-scoped
//          deployment that can be validated, previewed (what-if), and applied via
//          the deploy-sovereign-lz GitHub Actions workflow.
//
// MODULES DEPLOYED:
//   1. Policy        – sovereign-policy-initiative    (subscription scope)
//   2. TLS           – sovereign-tls-enforcement      (subscription scope)
//   3. RBAC          – sovereign-rbac-assignments      (subscription scope)
//   4. Key Vault/CMK – sovereign-keyvault-cmk          (resource group scope)
//   5. Confidential VM – sovereign-confidential-vm     (resource group scope)
//   6. AKS Node Pool – sovereign-confidential-aks-nodepool (resource group scope)
//   7. Arc Governance – sovereign-arc-governance        (resource group scope)

targetScope = 'subscription'

// ---------------------------------------------------------------------------
// Global Parameters
// ---------------------------------------------------------------------------

@description('Primary Azure region for sovereign resources')
param location string

@description('Environment label (dev, prod)')
@allowed([
  'dev'
  'prod'
])
param environment string = 'dev'

@description('Tags applied to every resource')
param tags object = {
  environment: environment
  managedBy: 'sovereign-landing-zone'
  dataClassification: 'Sovereign'
}

// ---------------------------------------------------------------------------
// Policy & Governance Parameters
// ---------------------------------------------------------------------------

@description('Allowed Azure regions for resource deployment')
param allowedLocations array

@description('Enforcement mode for policy assignments')
@allowed([
  'Default'
  'DoNotEnforce'
])
param policyEnforcementMode string = 'Default'

@description('Minimum TLS version to enforce')
@allowed([
  'TLS1_2'
  'TLS1_3'
])
param minimumTlsVersion string = 'TLS1_2'

// ---------------------------------------------------------------------------
// RBAC Parameters
// ---------------------------------------------------------------------------

@description('Object ID of the SovereignOps Entra ID security group')
param sovereignOpsGroupObjectId string

// ---------------------------------------------------------------------------
// Resource Group & Networking Parameters
// ---------------------------------------------------------------------------

@description('Name of the resource group for sovereign workloads')
param workloadResourceGroupName string = 'rg-sovereign-${environment}'

@description('Name of the resource group for Arc governance resources')
param arcResourceGroupName string = 'rg-sovereign-arc-${environment}'

@description('Resource ID of the subnet for private endpoints and VM NICs')
param workloadSubnetId string = ''

// ---------------------------------------------------------------------------
// Key Vault Parameters
// ---------------------------------------------------------------------------

@description('Name for the sovereign Key Vault (must be globally unique)')
@minLength(3)
@maxLength(24)
param keyVaultName string

// ---------------------------------------------------------------------------
// Confidential VM Parameters (optional — deploy only when subnetId provided)
// ---------------------------------------------------------------------------

@description('Deploy a confidential VM')
param deployConfidentialVm bool = false

@description('Name of the confidential VM')
param confidentialVmName string = 'cvm-sovereign-${environment}'

@description('SSH public key for VM authentication')
@secure()
param sshPublicKey string = ''

// ---------------------------------------------------------------------------
// AKS Confidential Node Pool Parameters (optional)
// ---------------------------------------------------------------------------

@description('Deploy an AKS confidential node pool')
param deployConfidentialAksNodePool bool = false

@description('Name of the existing AKS cluster')
param aksClusterName string = ''

// ---------------------------------------------------------------------------
// Resource Groups
// ---------------------------------------------------------------------------

resource workloadRg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: workloadResourceGroupName
  location: location
  tags: tags
}

resource arcRg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: arcResourceGroupName
  location: location
  tags: tags
}

// ---------------------------------------------------------------------------
// Module 1 – Policy Initiative (subscription scope)
// ---------------------------------------------------------------------------

module policyInitiative '../../modules/sovereign/policy/sovereign-policy-initiative.bicep' = {
  name: 'deploy-policy-initiative'
  params: {
    allowedLocations: allowedLocations
    enforcementMode: policyEnforcementMode
    minimumTlsVersion: minimumTlsVersion
  }
}

// ---------------------------------------------------------------------------
// Module 2 – TLS Enforcement (subscription scope)
// ---------------------------------------------------------------------------

module tlsEnforcement '../../modules/sovereign/encryption/sovereign-tls-enforcement.bicep' = {
  name: 'deploy-tls-enforcement'
  params: {
    minimumTlsVersion: minimumTlsVersion
    enforcementMode: policyEnforcementMode
  }
}

// ---------------------------------------------------------------------------
// Module 3 – RBAC Assignments (subscription scope)
// ---------------------------------------------------------------------------

module rbacAssignments '../../modules/sovereign/identity/sovereign-rbac-assignments.bicep' = {
  name: 'deploy-rbac-assignments'
  params: {
    sovereignOpsGroupObjectId: sovereignOpsGroupObjectId
  }
}

// ---------------------------------------------------------------------------
// Module 4 – Key Vault with CMK support (resource group scope)
// ---------------------------------------------------------------------------

module keyVault '../../modules/sovereign/encryption/sovereign-keyvault-cmk.bicep' = {
  name: 'deploy-keyvault-cmk'
  scope: workloadRg
  params: {
    keyVaultName: keyVaultName
    location: location
    privateEndpointSubnetId: workloadSubnetId
    tags: tags
  }
}

// ---------------------------------------------------------------------------
// Module 5 – Confidential VM (resource group scope, optional)
// ---------------------------------------------------------------------------

module confidentialVm '../../modules/sovereign/confidential-compute/sovereign-confidential-vm.bicep' = if (deployConfidentialVm && workloadSubnetId != '') {
  name: 'deploy-confidential-vm'
  scope: workloadRg
  params: {
    vmName: confidentialVmName
    location: location
    subnetId: workloadSubnetId
    sshPublicKey: sshPublicKey
    tags: tags
  }
}

// ---------------------------------------------------------------------------
// Module 6 – AKS Confidential Node Pool (resource group scope, optional)
// ---------------------------------------------------------------------------

module aksNodePool '../../modules/sovereign/confidential-compute/sovereign-confidential-aks-nodepool.bicep' = if (deployConfidentialAksNodePool && aksClusterName != '') {
  name: 'deploy-confidential-aks-nodepool'
  scope: workloadRg
  params: {
    aksClusterName: aksClusterName
    tags: tags
  }
}

// ---------------------------------------------------------------------------
// Module 7 – Arc Governance (resource group scope)
// ---------------------------------------------------------------------------

module arcGovernance '../../modules/sovereign/hybrid-arc/sovereign-arc-governance.bicep' = {
  name: 'deploy-arc-governance'
  scope: arcRg
  params: {
    location: location
    tags: tags
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

output policyInitiativeId string = policyInitiative.outputs.initiativeId
output tlsStoragePolicyId string = tlsEnforcement.outputs.storagePolicyAssignmentId
output rbacAssignmentIds array = rbacAssignments.outputs.roleAssignmentIds
output keyVaultId string = keyVault.outputs.keyVaultId
output keyVaultUri string = keyVault.outputs.keyVaultUri
output arcLogAnalyticsWorkspaceId string = arcGovernance.outputs.logAnalyticsWorkspaceId
