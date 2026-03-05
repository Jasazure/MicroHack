// MODULE: sovereign-confidential-aks-nodepool
// PURPOSE: AKS node pool using confidential VM SKU with AMD SEV-SNP,
//          taint and label for workload isolation.
// SOURCE: REUSE_CATALOG items tagged Confidential Compute
//         - solution-05.md (EXTRACT PATTERN)
//         - cvm-attestation-pod.yaml (DIRECT REUSE)

targetScope = 'resourceGroup'

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------

@description('Name of the existing AKS cluster')
param aksClusterName string

@description('Name for the confidential node pool')
@maxLength(12)
param nodePoolName string = 'cvmnodepool'

@description('Confidential VM SKU for the node pool (AMD SEV-SNP enabled)')
@allowed([
  'Standard_DC2as_v5'
  'Standard_DC4as_v5'
  'Standard_DC8as_v5'
])
param vmSize string = 'Standard_DC2as_v5'

@description('Number of nodes in the confidential node pool')
@minValue(1)
@maxValue(100)
param nodeCount int = 1

@description('Minimum number of nodes when autoscaling is enabled')
@minValue(1)
param minCount int = 1

@description('Maximum number of nodes when autoscaling is enabled')
@minValue(1)
param maxCount int = 3

@description('Enable cluster autoscaler for this node pool')
param enableAutoScaling bool = false

@description('OS disk size in GB')
param osDiskSizeGB int = 128

@description('Kubernetes labels to apply to the confidential node pool')
param nodeLabels object = {
  'azure.com/confidential-computing': 'true'
  workload: 'confidential'
}

@description('Taints for workload isolation on the confidential node pool')
param nodeTaints array = [
  'confidential=true:NoSchedule'
]

@description('Node pool mode')
@allowed([
  'User'
  'System'
])
param mode string = 'User'

@description('Tags to apply to the node pool')
param tags object = {}

// ---------------------------------------------------------------------------
// Resources
// ---------------------------------------------------------------------------

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-06-02-preview' existing = {
  name: aksClusterName
}

resource confidentialNodePool 'Microsoft.ContainerService/managedClusters/agentPools@2024-06-02-preview' = {
  parent: aksCluster
  name: nodePoolName
  properties: {
    vmSize: vmSize
    count: nodeCount
    minCount: enableAutoScaling ? minCount : null
    maxCount: enableAutoScaling ? maxCount : null
    enableAutoScaling: enableAutoScaling
    osDiskSizeGB: osDiskSizeGB
    osType: 'Linux'
    mode: mode
    nodeLabels: nodeLabels
    nodeTaints: nodeTaints
    tags: tags
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

output nodePoolName string = confidentialNodePool.name
output nodePoolId string = confidentialNodePool.id
output nodePoolVmSize string = confidentialNodePool.properties.vmSize
