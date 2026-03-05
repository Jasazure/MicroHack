// MODULE: sovereign-policy-initiative
// PURPOSE: Azure Policy initiative enforcing sovereign baseline controls
//          (allowed regions, mandatory tags, network controls, CMK enforcement).
// SOURCE: REUSE_CATALOG items tagged Policy and Governance
//         - sovereign-cloud-initiative.json (ADAPT AND PARAMETERIZE)
//         - solution-01.md (EXTRACT PATTERN)
//         - solution-03.md (EXTRACT PATTERN)

targetScope = 'subscription'

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------

@description('Display name for the sovereign policy initiative')
param initiativeName string = 'sovereign-baseline-initiative'

@description('Description for the initiative')
param initiativeDisplayName string = 'Sovereign Cloud Baseline Controls'

@description('List of allowed Azure regions for resource deployment')
param allowedLocations array

@description('Tag name required on all resources (e.g., DataClassification)')
param mandatoryTagName string = 'DataClassification'

@description('Tag value required on all resources (e.g., Sovereign)')
param mandatoryTagValue string = 'Sovereign'

@description('List of resource types that are not allowed (e.g., Microsoft.Network/publicIPAddresses)')
param deniedResourceTypes array = [
  'Microsoft.Network/publicIPAddresses'
]

@description('Enforcement mode for the policy assignment')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'

@description('Minimum TLS version to enforce across applicable services')
@allowed([
  'TLS1_2'
  'TLS1_3'
])
param minimumTlsVersion string = 'TLS1_2'

// ---------------------------------------------------------------------------
// Variables
// ---------------------------------------------------------------------------

var policyDefinitions = [
  {
    // Allowed locations for resources
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
    parameters: {
      listOfAllowedLocations: {
        value: allowedLocations
      }
    }
  }
  {
    // Allowed locations for resource groups
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
    parameters: {
      listOfAllowedLocations: {
        value: allowedLocations
      }
    }
  }
  {
    // Require tag and its value
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62'
    parameters: {
      tagName: {
        value: mandatoryTagName
      }
      tagValue: {
        value: mandatoryTagValue
      }
    }
  }
  {
    // Not allowed resource types (e.g., block public IPs)
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
    parameters: {
      listOfResourceTypesNotAllowed: {
        value: deniedResourceTypes
      }
    }
  }
  {
    // Storage accounts should have the specified minimum TLS version
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/fe83a0eb-a853-422d-aac2-1bffd182c5d0'
    parameters: {
      effect: {
        value: 'Deny'
      }
      minimumTlsVersion: {
        value: minimumTlsVersion
      }
    }
  }
]

// ---------------------------------------------------------------------------
// Resources
// ---------------------------------------------------------------------------

resource sovereignInitiative 'Microsoft.Authorization/policySetDefinitions@2024-05-01' = {
  name: initiativeName
  properties: {
    displayName: initiativeDisplayName
    description: 'Sovereign baseline controls: allowed regions, mandatory tags, network controls, TLS enforcement.'
    policyType: 'Custom'
    metadata: {
      category: 'Sovereign Cloud'
      version: '1.0.0'
    }
    policyDefinitions: policyDefinitions
  }
}

resource sovereignAssignment 'Microsoft.Authorization/policyAssignments@2024-05-01' = {
  name: '${initiativeName}-assignment'
  properties: {
    displayName: '${initiativeDisplayName} Assignment'
    policyDefinitionId: sovereignInitiative.id
    enforcementMode: enforcementMode
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

output initiativeId string = sovereignInitiative.id
output assignmentId string = sovereignAssignment.id
output initiativeName string = sovereignInitiative.name
