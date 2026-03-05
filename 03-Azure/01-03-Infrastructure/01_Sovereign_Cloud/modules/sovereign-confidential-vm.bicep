// MODULE: sovereign-confidential-vm
// PURPOSE: Confidential VM deployment with AMD SEV-SNP, attestation
//          provider reference, and managed identity.
// SOURCE: REUSE_CATALOG items tagged Confidential Compute
//         - solution-04.md (EXTRACT PATTERN)

targetScope = 'resourceGroup'

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------

@description('Name of the Confidential VM')
param vmName string

@description('Azure region (must support AMD SEV-SNP confidential VMs)')
param location string = resourceGroup().location

@description('Confidential VM size with AMD SEV-SNP support')
@allowed([
  'Standard_DC2as_v5'
  'Standard_DC4as_v5'
  'Standard_DC8as_v5'
  'Standard_DC2as_v6'
  'Standard_DC4as_v6'
  'Standard_DC8as_v6'
])
param vmSize string = 'Standard_DC2as_v5'

@description('Admin username for the VM')
param adminUsername string = 'azureuser'

@description('SSH public key for VM authentication')
@secure()
param sshPublicKey string

@description('Resource ID of the subnet for the VM NIC')
param subnetId string

@description('OS image reference for the Confidential VM')
param imageReference object = {
  publisher: 'Canonical'
  offer: '0001-com-ubuntu-confidential-vm-jammy'
  sku: '22_04-lts-cvm'
  version: 'latest'
}

@description('Security type for the VM (must be ConfidentialVM for SEV-SNP)')
@allowed([
  'ConfidentialVM'
])
param securityType string = 'ConfidentialVM'

@description('Enable Secure Boot on the VM')
param secureBootEnabled bool = true

@description('Enable vTPM on the VM')
param vTpmEnabled bool = true

@description('Resource ID of an existing Azure Attestation provider (optional)')
param attestationProviderUri string = ''

@description('Tags to apply to all resources')
param tags object = {}

// ---------------------------------------------------------------------------
// Resources
// ---------------------------------------------------------------------------

resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: '${vmName}-nic'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource confidentialVm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: imageReference
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          securityProfile: {
            securityEncryptionType: 'VMGuestStateOnly'
          }
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    securityProfile: {
      securityType: securityType
      uefiSettings: {
        secureBootEnabled: secureBootEnabled
        vTpmEnabled: vTpmEnabled
      }
    }
  }
}

// Guest Attestation extension — validates TEE integrity via Azure Attestation
resource guestAttestationExtension 'Microsoft.Compute/virtualMachines/extensions@2024-07-01' = if (attestationProviderUri != '') {
  parent: confidentialVm
  name: 'GuestAttestation'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Security.LinuxAttestation'
    type: 'GuestAttestation'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    settings: {
      AttestationConfig: {
        MaaSettings: {
          maaEndpoint: attestationProviderUri
          maaTenantName: 'GuestAttestation'
        }
        AscSettings: {
          ascReportingEndpoint: ''
          ascReportingFrequency: ''
        }
        useCustomToken: 'false'
        disableAlerts: 'false'
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

output vmId string = confidentialVm.id
output vmName string = confidentialVm.name
output vmPrincipalId string = confidentialVm.identity.principalId
