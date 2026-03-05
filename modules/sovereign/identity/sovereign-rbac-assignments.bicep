// MODULE: sovereign-rbac-assignments
// PURPOSE: Scoped RBAC role assignments for a SovereignOps team at
//          management group or subscription scope.
// SOURCE: REUSE_CATALOG items tagged RBAC and Identity
//         - 3-rbac.ps1 (ADAPT AND PARAMETERIZE)
//         - solution-01.md (EXTRACT PATTERN)

targetScope = 'subscription'

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------

@description('Object ID of the SovereignOps Entra ID security group')
param sovereignOpsGroupObjectId string

@description('Principal type for the role assignment')
@allowed([
  'Group'
  'User'
  'ServicePrincipal'
])
param principalType string = 'Group'

@description('Array of built-in role definition names to assign to the SovereignOps group')
param roleDefinitionNames array = [
  'Security Reader'
  'Resource Policy Contributor'
]

@description('Array of built-in role definition IDs corresponding to roleDefinitionNames. If empty, well-known IDs are used.')
param roleDefinitionIds array = [
  // Security Reader
  '39bc4728-0917-49c7-9d2c-d95423bc2eb4'
  // Resource Policy Contributor
  '36243c78-bf99-4830-9176-9f8d646f12ab'
]

@description('Description added to each role assignment for auditing')
param assignmentDescription string = 'Sovereign Cloud landing zone RBAC for SovereignOps team'

// ---------------------------------------------------------------------------
// Resources
// ---------------------------------------------------------------------------

resource roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleId, index) in roleDefinitionIds: {
    name: guid(subscription().id, sovereignOpsGroupObjectId, roleId)
    properties: {
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleId)
      principalId: sovereignOpsGroupObjectId
      principalType: principalType
      description: '${assignmentDescription} – ${roleDefinitionNames[index]}'
    }
  }
]

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

output roleAssignmentIds array = [
  for (roleId, index) in roleDefinitionIds: roleAssignments[index].id
]
output assignedRoles array = roleDefinitionNames
output principalId string = sovereignOpsGroupObjectId
