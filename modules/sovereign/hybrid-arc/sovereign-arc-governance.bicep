// MODULE: sovereign-arc-governance
// PURPOSE: Azure Policy assignments and Machine Configuration for
//          Arc-enabled servers including compliance reporting.
// SOURCE: REUSE_CATALOG items tagged Hybrid Arc and Azure Local
//         - solution-06.md (EXTRACT PATTERN)

targetScope = 'resourceGroup'

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------

@description('Resource group scope for Arc governance policy assignments')
param location string = resourceGroup().location

@description('Enable SSH posture control policy for Arc-enabled Linux servers')
param enableSshPostureControl bool = true

@description('Include Arc-connected servers in Machine Configuration policies')
param includeArcServers bool = true

@description('Enforcement mode for the policy assignments')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'

@description('Log Analytics workspace resource ID for compliance reporting')
param logAnalyticsWorkspaceId string = ''

@description('Tags to apply to resources')
param tags object = {}

// ---------------------------------------------------------------------------
// Resources
// ---------------------------------------------------------------------------

// Deploy Machine Configuration prerequisites for Arc-enabled servers
// Built-in policy: Deploy prerequisites to enable Guest Configuration policies on virtual machines
resource guestConfigPrerequisites 'Microsoft.Authorization/policyAssignments@2024-05-01' = {
  name: 'arc-guest-config-prereqs'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Deploy Machine Configuration prerequisites for Arc servers'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/12794019-7a00-42cf-95c2-882ead6a5b75'
    enforcementMode: enforcementMode
    parameters: {
      IncludeArcMachines: {
        value: includeArcServers ? 'true' : 'false'
      }
    }
  }
}

// SSH posture control for Linux servers (powered by OSConfig)
resource sshPosturePolicy 'Microsoft.Authorization/policyAssignments@2024-05-01' = if (enableSshPostureControl) {
  name: 'arc-ssh-posture-control'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Configure SSH security posture for Linux (powered by OSConfig)'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/a8f3e6a6-dcd2-434c-b0f7-6f309ce913b4'
    enforcementMode: enforcementMode
    parameters: {
      IncludeArcMachines: {
        value: includeArcServers ? 'true' : 'false'
      }
    }
  }
}

// Audit: Guest Configuration extension should be installed on machines
resource guestConfigExtensionAudit 'Microsoft.Authorization/policyAssignments@2024-05-01' = {
  name: 'arc-guest-config-ext-audit'
  location: location
  properties: {
    displayName: 'Audit Guest Configuration extension on Arc servers'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/ae89ebca-1c92-4898-ac2c-9f63decb045c'
    enforcementMode: enforcementMode
    parameters: {}
  }
}

// Compliance reporting: Log Analytics workspace for Arc server diagnostics
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = if (logAnalyticsWorkspaceId == '') {
  name: 'law-arc-governance'
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 90
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

output guestConfigPrerequisitesAssignmentId string = guestConfigPrerequisites.id
output sshPosturePolicyAssignmentId string = enableSshPostureControl ? sshPosturePolicy.id : ''
output guestConfigExtensionAuditAssignmentId string = guestConfigExtensionAudit.id
output logAnalyticsWorkspaceId string = (logAnalyticsWorkspaceId != '') ? logAnalyticsWorkspaceId : logAnalyticsWorkspace.id
