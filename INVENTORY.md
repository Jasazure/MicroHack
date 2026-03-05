# MicroHack Repository -- Complete File Inventory

This document provides an exhaustive file inventory of the Jasazure/MicroHack repository (repo ID 1172424167). It enumerates every file in six target directories with path, type, description, and reuse classification, followed by summaries of all other top-level directories, and a mapping of challenge steps to automation feasibility ratings from CHALLENGES_ANALYSIS.md.

---

## 01-03-Infrastructure/01_Sovereign_Cloud

Directory: `03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/`

| Full Relative Path | File Type / Language | Description | Reuse |
|---|---|---|---|
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/Readme.md | Markdown | Main overview and introduction for the Sovereign Cloud MicroHack scenario. | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/img/Microsoft_Sovereign_Cloud.png | PNG image | Architecture diagram illustrating the Microsoft Sovereign Cloud reference design. | LOW |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-01.md | Markdown | Challenge 1 instructions: enforce sovereign controls with Azure Policy and RBAC. | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-02.md | Markdown | Challenge 2 instructions: encryption at rest with customer-managed keys (CMKs). | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-03.md | Markdown | Challenge 3 instructions: encryption in transit by enforcing TLS. | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-04.md | Markdown | Challenge 4 instructions: confidential compute VM with attestation. | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-05.md | Markdown | Challenge 5 instructions: confidential VMs in AKS. | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-06.md | Markdown | Challenge 6 instructions: hybrid cloud with Azure Arc and Azure Local. | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/finish.md | Markdown | Completion summary and wrap-up for the Sovereign Cloud MicroHack. | LOW |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/cleanup/1-resource-groups.ps1 | PowerShell | Bulk-deletes resource groups matching a naming pattern across multiple subscriptions for lab cleanup. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/subscription-preparations/1-resource-providers.ps1 | PowerShell | Registers required Azure resource providers (Arc, Stack HCI, confidential computing, Key Vault) across subscriptions. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/subscription-preparations/2-vcpu-quotas.ps1 | PowerShell | Checks and calculates vCPU quota requirements for the Sovereign Cloud lab based on user count. | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/subscription-preparations/3-rbac.ps1 | PowerShell | Creates a custom "Deployment Validator" RBAC role and assigns Security Reader and Resource Policy Contributor roles to lab users. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/subscription-preparations/4-resource-groups.ps1 | PowerShell | Creates numbered resource groups and assigns Owner role to each MicroHack participant for their lab environment. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/README.md | Markdown | Documents ArcBox and LocalBox deployment for Challenge 6, including features, requirements, and estimated costs. | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/deploy-arcbox.ps1 | PowerShell | Deploys an Azure Arc Jumpstart ArcBox environment with nested Arc-enabled VMs and Log Analytics workspace. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/deploy-localbox.ps1 | PowerShell | Deploys an Azure Arc Jumpstart LocalBox for testing Azure Local features with a virtualized cluster and Arc Resource Bridge. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/img/add_logical_network_01.jpg | JPEG image | Screenshot showing the first step of adding a logical network in Azure Local. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/img/add_logical_network_02.jpg | JPEG image | Screenshot showing the second step of logical network configuration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/img/add_logical_network_03.jpg | JPEG image | Screenshot showing the third step of logical network configuration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/img/add_rbac_01.jpg | JPEG image | Screenshot showing the first step of RBAC assignment in Azure Local. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/img/add_rbac_02.jpg | JPEG image | Screenshot showing the second step of RBAC role selection. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/img/add_rbac_03.jpg | JPEG image | Screenshot showing the third step of RBAC member selection. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/img/add_rbac_04.jpg | JPEG image | Screenshot showing the fourth step of RBAC confirmation. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/img/add_rbac_05.jpg | JPEG image | Screenshot showing the fifth step of RBAC review. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/img/add_rbac_06.jpg | JPEG image | Screenshot showing the final RBAC assignment confirmation. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/img/add_vm_image_win_01.jpg | JPEG image | Screenshot showing the first step of adding a Windows VM image in Azure Local. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/img/add_vm_image_win_02.jpg | JPEG image | Screenshot showing the second step of Windows VM image configuration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/solution-01.md | Markdown | Step-by-step solution guide for Challenge 1 covering Azure Policy and custom RBAC role creation. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/sovereign-cloud-initiative.json | JSON | Azure Policy initiative definition restricting resources to sovereign cloud regions (Norway, Germany, North Europe). | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/challenge1-policy-scope.jpg | JPEG image | Screenshot showing how to define the policy scope for sovereign cloud controls. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/cloud-shell.jpg | JPEG image | Screenshot of Cloud Shell used during Challenge 1 policy deployment. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/cloud-shell2.jpg | JPEG image | Screenshot of Cloud Shell showing a second command in the policy setup. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/cloud-shell3.jpg | JPEG image | Screenshot of Cloud Shell showing a third command in the policy setup. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/cloud-shell4.jpg | JPEG image | Screenshot of Cloud Shell showing additional policy commands. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/policy-enforcement-mode.jpg | JPEG image | Screenshot showing Azure Policy enforcement mode configuration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/task-9-test-pip-creation.jpg | JPEG image | Screenshot showing public IP creation test to validate policy enforcement. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/task-9-test-pip-creation-02.jpg | JPEG image | Screenshot showing the result of the public IP creation policy test. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/task10-portal.jpg | JPEG image | Screenshot of portal-based policy verification in Task 10. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/task10-portal-02.jpg | JPEG image | Screenshot of additional portal policy verification. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/task10-portal-03.jpg | JPEG image | Screenshot of final portal policy verification step. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/img/task11-portal.jpg | JPEG image | Screenshot of portal showing Task 11 policy compliance results. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-02/solution-02.md | Markdown | Step-by-step solution guide for Challenge 2 covering Key Vault and CMK encryption setup. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-02/images/key-vault.jpg | JPEG image | Screenshot showing Key Vault creation in the Azure portal. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-02/images/key-vault-02.jpg | JPEG image | Screenshot showing Key Vault key configuration for CMK. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-02/images/storage-account.jpg | JPEG image | Screenshot showing storage account encryption with CMK. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-03/solution-03.md | Markdown | Step-by-step solution guide for Challenge 3 covering TLS enforcement and storage logging. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-03/images/storage_01.png | PNG image | Screenshot showing storage account TLS minimum version setting. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-03/images/storage_02.png | PNG image | Screenshot showing storage account secure transfer configuration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-03/images/storage_03.png | PNG image | Screenshot showing storage account diagnostic settings. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-03/images/storage_04.png | PNG image | Screenshot showing storage account logging verification. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-03/images/log_analytics_01.png | PNG image | Screenshot showing Log Analytics workspace creation for storage logging. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-03/images/log_analytics_02.png | PNG image | Screenshot showing Log Analytics query results for storage audit. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-03/images/policy_01.png | PNG image | Screenshot showing Azure Policy assignment for TLS enforcement. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/solution-04.md | Markdown | Step-by-step solution guide for Challenge 4 covering confidential VM deployment and attestation via CLI. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/portal-guide.md | Markdown | Portal-based walkthrough for creating and attesting a confidential VM. | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/attestation-default-provider.png | PNG image | Screenshot showing the default attestation provider in Azure. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/attestation-provider.png | PNG image | Screenshot showing attestation provider overview. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/attestation-specified-provider.png | PNG image | Screenshot showing a specified attestation provider configuration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/attestation-workflow.png | PNG image | Diagram showing the confidential VM attestation workflow. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/azbastion-create.png | PNG image | Screenshot showing Azure Bastion host creation. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/azbastion-resource.png | PNG image | Screenshot showing the created Azure Bastion resource. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/create-attest-service.png | PNG image | Screenshot showing the creation of an attestation service. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/create-resource-group.png | PNG image | Screenshot showing resource group creation for the CVM lab. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-access-config.png | PNG image | Screenshot showing Key Vault access configuration for CVM. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-add-role-assignment.png | PNG image | Screenshot showing Key Vault RBAC role assignment. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-cloud-shell-activate.png | PNG image | Screenshot showing Cloud Shell activation for Key Vault operations. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-cloud-shell-activated.png | PNG image | Screenshot showing an active Cloud Shell session for Key Vault. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-create-a-key.png | PNG image | Screenshot showing Key Vault key creation step. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-create.png | PNG image | Screenshot showing Key Vault creation in the portal. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-gen-ssh-key-pair.png | PNG image | Screenshot showing SSH key pair generation via Key Vault. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-generate-key.png | PNG image | Screenshot showing Key Vault key generation completion. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-rbac-choose-secrets-officer.png | PNG image | Screenshot showing Key Vault Secrets Officer role selection. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-rbac-select-members.png | PNG image | Screenshot showing Key Vault RBAC member selection. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-secret-copy-public-key.png | PNG image | Screenshot showing public key copy from Key Vault secret. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-secret-set-privkey.png | PNG image | Screenshot showing private key upload to Key Vault. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/kv-secret-set-pubkey.png | PNG image | Screenshot showing public key upload to Key Vault. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/portal-attestation-provider-copy-uri.png | PNG image | Screenshot showing attestation provider URI copy from the portal. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/portal-attestation-service.png | PNG image | Screenshot showing the attestation service overview in the portal. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/review-create-attest-service.png | PNG image | Screenshot showing the review-and-create step for the attestation service. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/select-resource-groups.png | PNG image | Screenshot showing resource group selection for the CVM lab. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-attest-client-inspect-output.png | PNG image | Screenshot showing attestation client inspection output. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-attest-client-inspect-output2.png | PNG image | Screenshot showing additional attestation client output details. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-basics-part1.png | PNG image | Screenshot showing VM creation basics (name, region, size). | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-basics-use-publickey.png | PNG image | Screenshot showing VM creation with public key authentication. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-basics-vmsize-dc4es_v5.png | PNG image | Screenshot showing DC4es_v5 confidential VM size selection. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-bastion-session.png | PNG image | Screenshot showing an active Bastion session to the CVM. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-bastion-settings.png | PNG image | Screenshot showing Bastion connection settings for the CVM. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-build-attest-client.png | PNG image | Screenshot showing the build process of the attestation client on the CVM. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-connect-via-bastion.png | PNG image | Screenshot showing the connect-via-Bastion option for the CVM. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-daemon-prompts.png | PNG image | Screenshot showing daemon restart prompts during CVM setup. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-image-find-ubuntu-cvm.png | PNG image | Screenshot showing Ubuntu CVM image search in the marketplace. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-image-select-ubuntu-cvm-gen2.png | PNG image | Screenshot showing selection of Ubuntu CVM Gen2 image. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-network-interface.png | PNG image | Screenshot showing CVM network interface configuration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-resource.png | PNG image | Screenshot showing the deployed CVM resource in the portal. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-run-attest-client.png | PNG image | Screenshot showing the attestation client execution on the CVM. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vm-system-managed-identity.png | PNG image | Screenshot showing system-assigned managed identity enabled on the CVM. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vnet-add-subnet.png | PNG image | Screenshot showing subnet addition to the VNet for the CVM. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vnet-azurebastion-subnet.png | PNG image | Screenshot showing AzureBastionSubnet creation. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vnet-default-subnet.png | PNG image | Screenshot showing the default subnet configuration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vnet-instance-details.png | PNG image | Screenshot showing VNet instance details. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vnet-resource.png | PNG image | Screenshot showing the deployed VNet resource. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/images/vnet-subnet-snapshot.png | PNG image | Screenshot showing a snapshot of all VNet subnets. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-05/solution-05.md | Markdown | Step-by-step solution guide for Challenge 5 covering AKS with confidential node pool and attestation. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-05/portal-guide.md | Markdown | Portal-based walkthrough for creating an AKS cluster with confidential compute nodes. | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-05/resources/cvm-attestation-pod.yaml | YAML (Kubernetes) | Kubernetes pod manifest for running confidential VM attestation tests with TPM access on AKS. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-05/images/aks.png | PNG image | Screenshot showing AKS cluster creation overview. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-05/images/aks-02.png | PNG image | Screenshot showing AKS confidential node pool configuration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-05/images/aks-03.png | PNG image | Screenshot showing AKS cluster deployment review. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/solution-06.md | Markdown | Step-by-step solution guide for Challenge 6 covering Azure Arc, Azure Local, and hybrid management. | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/arcbox_01.jpg | JPEG image | Screenshot showing the ArcBox environment overview in the portal. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/aum_01.jpg | JPEG image | Screenshot showing Azure Update Manager overview for Arc-enabled servers. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/aum_02.jpg | JPEG image | Screenshot showing Azure Update Manager assessment results. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/aum_03.jpg | JPEG image | Screenshot showing Azure Update Manager update scheduling. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/dfc_01.jpg | JPEG image | Screenshot showing Defender for Cloud security posture for Arc resources. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/dfc_02.jpg | JPEG image | Screenshot showing Defender for Cloud recommendations for Arc-enabled servers. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_01.jpg | JPEG image | Screenshot showing the LocalBox deployment environment. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_02.jpg | JPEG image | Screenshot showing LocalBox Azure Local cluster registration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_03.jpg | JPEG image | Screenshot showing LocalBox cluster node status. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_04.jpg | JPEG image | Screenshot showing LocalBox Arc Resource Bridge status. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_05.jpg | JPEG image | Screenshot showing LocalBox VM gallery images. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_06.jpg | JPEG image | Screenshot showing LocalBox logical network setup. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_07.jpg | JPEG image | Screenshot showing LocalBox VM deployment in progress. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_08.jpg | JPEG image | Screenshot showing LocalBox deployed VM details. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_09.jpg | JPEG image | Screenshot showing LocalBox VM management options. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_10.jpg | JPEG image | Screenshot showing LocalBox policy compliance status. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_11.jpg | JPEG image | Screenshot showing LocalBox Defender for Cloud integration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/localbox_12.jpg | JPEG image | Screenshot showing LocalBox update management configuration. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/ssh_posture_01.jpg | JPEG image | Screenshot showing SSH security posture assessment step 1. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/ssh_posture_02.jpg | JPEG image | Screenshot showing SSH security posture assessment step 2. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/ssh_posture_03.jpg | JPEG image | Screenshot showing SSH security posture assessment step 3. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/ssh_posture_04.jpg | JPEG image | Screenshot showing SSH security posture remediation step. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/ssh_posture_05.jpg | JPEG image | Screenshot showing SSH security posture validation. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/ssh_posture_06.jpg | JPEG image | Screenshot showing SSH posture compliance results. | SKIP |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/images/ssh_posture_07.jpg | JPEG image | Screenshot showing final SSH posture status. | SKIP |

**Total files in this directory: 135**

---

## 01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1

Directory: `03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/`

| Full Relative Path | File Type / Language | Description | Reuse |
|---|---|---|---|
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/.gitignore | Git config | Specifies files and directories to exclude from version control for the BCDR lab. | LOW |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/ReadMe.md | Markdown | Deployment instructions and prerequisites for the BCDR MicroHack lab infrastructure. | MEDIUM |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/setup.sh | Bash | Automated setup script orchestrating the complete BCDR lab deployment including prerequisites, parameters, and verification. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/validate-prerequisites.sh | Bash | Validates Azure CLI installation, authentication, permissions, and required resource providers before BCDR deployment. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/deploy-lab.ps1 | PowerShell | Controls deployment flow for BCDR lab resources scoped to subscription or resource group with optional access restrictions. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/deploy.json | JSON (ARM template) | ARM template defining BCDR infrastructure with source/target regions, VMs, networking, and storage resources. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/main.parameters.json | JSON (ARM parameters) | Parameter file specifying deployment prefix, regions, VM credentials, and VNet/subnet CIDR configurations. | MEDIUM |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/NETWORK/vnet.bicep | Bicep | Defines Azure Virtual Network resources with configurable subnets for the BCDR lab. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/NETWORK/nsg.bicep | Bicep | Defines Network Security Group rules for inbound and outbound traffic filtering. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/NETWORK/pip.bicep | Bicep | Defines Public IP address resources for load balancers and VMs. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/NETWORK/loadbalancer.bicep | Bicep | Defines Azure Load Balancer with health probes and load-balancing rules for the web tier. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/NETWORK/trafficmanager.bicep | Bicep | Defines Azure Traffic Manager profile for cross-region DNS-based traffic routing in BCDR scenarios. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/NETWORK/vnetpeer.bicep | Bicep | Defines bidirectional VNet peering between source and target region networks. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/VIRTUALMACHINE/vm.bicep | Bicep | Defines Windows Server Virtual Machine resources with data disks and boot diagnostics. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/VIRTUALMACHINE/avset.bicep | Bicep | Defines Availability Set resource for VM high availability within a region. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/VIRTUALMACHINE/VMEXTENSIONS/DeployIIS.ps1 | PowerShell | Installs IIS web server with a sample HTML/CSS page showing server name and location. | MEDIUM |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/VIRTUALMACHINE/VMEXTENSIONS/DeploySQLDB.ps1 | PowerShell | Deploys AdventureWorks SQL Server database with error logging and disk initialization. | MEDIUM |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/VIRTUALMACHINE/VMEXTENSIONS/wrapperScript.ps1 | PowerShell | Wrapper script that executes PowerShell commands with specified credentials on VMs. | LOW |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/VIRTUALMACHINE/VMEXTENSIONS/update-htmlcontent.ps1 | PowerShell | Retrieves VM metadata and updates the IIS website HTML with server name and location information. | LOW |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/VIRTUALMACHINE/VMEXTENSIONS/wadcfg.json | JSON | Windows Azure Diagnostics configuration defining VM performance counters, logs, and metrics collection. | MEDIUM |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/VIRTUALMACHINE/VMEXTENSIONS/AdventureWorks-oltp-install-script.zip | ZIP archive | Packaged AdventureWorks OLTP database installer for SQL Server lab setup. | LOW |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/VIRTUALMACHINE/VMEXTENSIONS/asrdemo.png | PNG image | Architecture diagram showing the ASR demo environment topology. | SKIP |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/VIRTUALMACHINE/VMEXTENSIONS/_asrdemo.png | PNG image | Backup copy of the ASR demo architecture diagram. | SKIP |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/STORAGE/storage.bicep | Bicep | Defines Azure Storage account resources for the BCDR lab. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/BASTION/bastion.bicep | Bicep | Defines Azure Bastion host for secure RDP/SSH access to lab VMs without public IPs. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/MONITORING/monitor.bicep | Bicep | Defines Log Analytics workspace and monitoring resources for BCDR observability. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/SECURITY/keyvault.bicep | Bicep | Defines Azure Key Vault for storing secrets and encryption keys used by the BCDR lab. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/SITERECOVERY/asrvault.bicep | Bicep | Defines Azure Site Recovery vault for VM replication and disaster recovery. | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/SITERECOVERY/automation.bicep | Bicep | Defines Azure Automation account and runbooks for Site Recovery orchestration. | HIGH |

**Total files in this directory: 29**

---

## 01-03-Infrastructure/07_Azure_Monitor/resources

Directory: `03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/`

| Full Relative Path | File Type / Language | Description | Reuse |
|---|---|---|---|
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/Readme.md | Markdown | Documents Azure resource quota requirements for single and multi-user deployments and setup instructions. | MEDIUM |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/ARM/template.json | JSON (ARM template) | ARM template defining the Azure Monitor lab infrastructure including VMs, networking, and diagnostics. | HIGH |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/scripts/challenge-5/create-custom-table.ps1 | PowerShell | Creates a custom Log Analytics table (MH_MONITORING_CL) for storing monitoring data via the DCR API. | HIGH |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/scripts/challenge-5/generate-logs.ps1 | PowerShell | Generates test log entries at specified intervals indefinitely for Log Analytics custom table ingestion. | MEDIUM |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/scripts/challenge-5/sample-data.json | JSON | Sample log entries with timestamps and random content for testing custom table ingestion. | LOW |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/README.md | Markdown | Terraform deployment guide with prerequisites and step-by-step instructions for the Monitor lab. | MEDIUM |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/main.tf | Terraform (HCL) | Root Terraform module configuring the Azure provider and calling environment sub-modules. | HIGH |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/locals.tf | Terraform (HCL) | Defines local values and computed variables used across the root Terraform configuration. | MEDIUM |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/variables.tf | Terraform (HCL) | Declares input variables (region, prefix, credentials) for the Terraform deployment. | MEDIUM |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/key-vault.tf | Terraform (HCL) | Defines Azure Key Vault resource for storing VM credentials and secrets. | HIGH |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/main.tf | Terraform (HCL) | Environment sub-module root that calls networking, compute, and gateway child modules. | HIGH |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/bastion.tf | Terraform (HCL) | Defines Azure Bastion host resource for secure access to monitoring lab VMs. | HIGH |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/network.tf | Terraform (HCL) | Defines VNet, subnets, and NSG resources for the monitoring lab network topology. | HIGH |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/app-gw.tf | Terraform (HCL) | Defines Azure Application Gateway with HTTP routing rules for the monitoring lab. | HIGH |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/vmss.tf | Terraform (HCL) | Defines Virtual Machine Scale Set for load-tested monitoring scenarios. | HIGH |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/outputs.tf | Terraform (HCL) | Declares output values exported from the environment module. | LOW |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/variables.tf | Terraform (HCL) | Declares input variables for the environment sub-module. | LOW |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/locals.tf | Terraform (HCL) | Defines local values for the environment sub-module. | LOW |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/web.conf | Text (config) | Nginx or web server configuration file used by VMSS instances in the monitoring lab. | MEDIUM |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/modules/vms/main.tf | Terraform (HCL) | Defines individual Virtual Machine resources with OS disk and network interface. | HIGH |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/modules/vms/variables.tf | Terraform (HCL) | Declares input variables for the VM child module. | LOW |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/modules/vms/outputs.tf | Terraform (HCL) | Declares output values from the VM child module. | LOW |

**Total files in this directory: 22**

---

## 99-PreparationHelpers

Directory: `03-Azure/99-PreparationHelpers/`

| Full Relative Path | File Type / Language | Description | Reuse |
|---|---|---|---|
| 03-Azure/99-PreparationHelpers/Readme.md | Markdown | Documents helper scripts for bulk-creating Entra ID users, groups, and admin accounts for multi-user MicroHack environments. | MEDIUM |
| 03-Azure/99-PreparationHelpers/Create Admin Users.ps1 | PowerShell | Creates 10 Entra ID admin accounts and 6 groups with subscription-level RBAC assignments for MicroHack facilitators. | HIGH |
| 03-Azure/99-PreparationHelpers/Create MH Users.ps1 | PowerShell | Creates 60 Entra ID user accounts (6 per group) for MicroHack participants with group membership assignments. | HIGH |

**Total files in this directory: 3**

---

## 99-MicroHack-Template

Directory: `99-MicroHack-Template/`

| Full Relative Path | File Type / Language | Description | Reuse |
|---|---|---|---|
| 99-MicroHack-Template/Readme.md | Markdown | Template README with standardized sections (intro, context, objectives, prerequisites, challenges) for creating new MicroHack scenarios. | HIGH |
| 99-MicroHack-Template/challenges/challenge-01.md | Markdown | Challenge 1 template with placeholder structure for defining learning objectives and tasks. | HIGH |
| 99-MicroHack-Template/challenges/challenge-02.md | Markdown | Challenge 2 template with placeholder structure for defining learning objectives and tasks. | HIGH |
| 99-MicroHack-Template/challenges/finish.md | Markdown | Completion and wrap-up template for concluding a MicroHack scenario. | MEDIUM |
| 99-MicroHack-Template/walkthrough/challenge-01/solution-01.md | Markdown | Solution template for Challenge 1 with placeholder structure for step-by-step instructions. | HIGH |
| 99-MicroHack-Template/walkthrough/challenge-02/solution-02.md | Markdown | Solution template for Challenge 2 with placeholder structure for step-by-step instructions. | HIGH |

**Total files in this directory: 6**

---

## .github

Directory: `.github/`

| Full Relative Path | File Type / Language | Description | Reuse |
|---|---|---|---|
| .github/CODEOWNERS | CODEOWNERS (text) | Assigns default code ownership to the @microsoft/microhack-repository team for pull request reviews. | HIGH |
| .github/ISSUE_TEMPLATE/bug.yaml | YAML (GitHub template) | GitHub issue template for reporting bugs with structured fields for description and reproduction steps. | MEDIUM |
| .github/ISSUE_TEMPLATE/featurerequest.yaml | YAML (GitHub template) | GitHub issue template for submitting feature requests with structured fields for rationale and scope. | MEDIUM |
| .github/ISSUE_TEMPLATE/request.yaml | YAML (GitHub template) | GitHub issue template for general requests with structured fields for description and context. | MEDIUM |
| .github/scripts/check_file_structure.py | Python | Validates file structure compliance for challenge and walkthrough directories in pull requests. | HIGH |
| .github/workflows/pr-compliance-check.yml | YAML (GitHub Actions) | GitHub Actions workflow that runs the file structure compliance check on PRs affecting MicroHack directories. | HIGH |

**Total files in this directory: 6**

---

## Other Top-Level Directories (Summaries)

| Directory | Summary |
|---|---|
| `01-Identity and Access Management/` | Contains MicroHack scenarios focused on Azure Active Directory and identity management topics. |
| `02-Security/` | Contains MicroHack scenarios for Azure security topics including Defender for Cloud and network security. |
| `03-Azure/` | The main directory housing all Azure-focused MicroHacks across App Innovation, Data, Infrastructure (including the Sovereign Cloud, BCDR, Arc, Migration, Monitor, and Oracle sub-scenarios), and SAP. |
| `04-Microsoft-365/` | Contains MicroHack scenarios related to Microsoft 365 services and administration. |
| `99-MicroHack-TemplateLink/` | Contains archived/zipped lab content packages for distribution of completed MicroHack scenarios. |
| `archive/` | Stores older or deprecated MicroHack materials that are no longer actively maintained. |
| `img/` | Contains logo and event banner graphics used for MicroHack branding and documentation. |

---

## CHALLENGES_ANALYSIS Summary

The following table maps each challenge step from `CHALLENGES_ANALYSIS.md` to its automation feasibility rating. Classifications are mapped as follows: Fully Automatable (originally marked as automatable via CLI/Bicep/Terraform/scripts), Partial (setup can be scripted but validation or review requires a human), Manual (requires human intervention such as portal UI, physical access, or decision-making).

### 1. App Innovation -- App Service to Container Apps

| # | Title | Automation Feasibility |
|---|-------|----------------------|
| 1 | Understand the migratable estate | Manual |
| 2 | Containerize the Application | Fully Automatable |
| 3 | Create the Container App | Fully Automatable |
| 4 | Make the Container App Production Ready | Partial |
| 5 | Host Your Own AI Models | Fully Automatable |

### 2. App Innovation -- AKS

| # | Title | Automation Feasibility |
|---|-------|----------------------|
| 1 | Create Azure Container Registry and Push Images | Fully Automatable |
| 2 | Create an AKS Cluster with ACR Integration | Fully Automatable |
| 3 | Deploy Applications on AKS | Fully Automatable |
| 4 | Expose Application with Load Balancer | Fully Automatable |
| 5 | Scaling in AKS | Fully Automatable |
| 6 | Persistent Storage in AKS | Fully Automatable |
| 7 | Backup and Restore with Azure Backup for AKS | Partial |
| 8 | Monitoring with Azure Managed Grafana | Partial |

### 3. Data -- SQL Modernization

| # | Title | Automation Feasibility |
|---|-------|----------------------|
| 1 | Prerequisites | Fully Automatable |
| 2 | SQL Assessment | Manual |
| 3 | SQL Migration | Partial |

### 4. Infrastructure -- Sovereign Cloud

| # | Title | Automation Feasibility |
|---|-------|----------------------|
| 1 | Enforce Sovereign Controls with Azure Policy and RBAC | Fully Automatable |
| 2 | Encryption at Rest with Customer-Managed Keys (CMKs) | Fully Automatable |
| 3 | Encryption in Transit: Enforcing TLS | Fully Automatable |
| 4 | Encryption in Use with Azure Confidential Compute -- VM | Partial |
| 5 | Encryption in Use with Confidential VMs in AKS | Partial |
| 6 | Operating a Sovereign Hybrid Cloud with Azure Arc and Azure Local | Manual |

### 5. Infrastructure -- Hybrid Azure Arc Servers

| # | Title | Automation Feasibility |
|---|-------|----------------------|
| 1 | Azure Arc prerequisites and onboarding | Partial |
| 2 | Azure Monitor integration | Fully Automatable |
| 3 | Access Azure resources using Managed Identities | Fully Automatable |
| 4 | Microsoft Defender for Cloud integration | Fully Automatable |
| 5 | Best Practices assessment for Windows Server | Manual |
| 6 | Activate ESU for Windows Server 2012 R2 (optional) | Fully Automatable |
| 7 | Azure Automanage Machine Configuration (optional) | Partial |

### 6. Infrastructure -- BCDR Azure Native

| # | Title | Automation Feasibility |
|---|-------|----------------------|
| 1 | Understand DR terms and define a DR strategy | Manual |
| 2 | Prerequisites and Landing Zone Preparation | Fully Automatable |
| 3 | Regional Protection (Backup) | Partial |
| 4 | Regional Disaster Recovery (DR) | Partial |
| 5 | Disaster Recovery across Azure Regions | Partial |
| 6 | Restore Web Application and verify Azure Storage DR | Manual |
| 7 | Failback to the Primary Region | Manual |
| 8 | Monitoring and Alerting for BCDR Operations (optional) | Fully Automatable |

### 7. Infrastructure -- Migration: Migrate and Secure to be AI Ready

| # | Title | Automation Feasibility |
|---|-------|----------------------|
| 1 | Prerequisites and landing zone preparation | Fully Automatable |
| 2 | Discover physical servers for the migration | Manual |
| 3 | Create a Business Case | Manual |
| 4 | Assess VMs for the migration | Manual |
| 5 | Migrate machines to Azure | Partial |
| 6 | Secure on Azure (optional) | Fully Automatable |
| 7 | Modernize with Azure (optional) | Manual |
| 8 | Deploy AI chat in App Service (optional) | Partial |

### 8. Infrastructure -- Azure Monitor

| # | Title | Automation Feasibility |
|---|-------|----------------------|
| 1 | Create Log Analytics Workspace and Dashboard | Fully Automatable |
| 2 | Configure Virtual Machine Logs | Partial |
| 3 | Enable Virtual Machine Insights | Fully Automatable |
| 4 | Create Alerts | Fully Automatable |
| 5 | Workbooks | Manual |
| 6 | Collect custom text logs with Azure Monitor Agent | Partial |

### 9. Infrastructure -- Oracle on Azure

| # | Title | Automation Feasibility |
|---|-------|----------------------|
| 1 | Create an Oracle Database@Azure (ODAA) Subscription | Manual |
| 2 | Create Azure ODAA Database Resources | Partial |
| 3 | Update the Oracle ADB NSG and DNS | Fully Automatable |
| 4 | Simulate the On-Premises Environment | Fully Automatable |
| 5 | Measure Network Performance to Oracle ADB | Fully Automatable |
| 6 | Setup High Availability for Oracle ADB | Partial |
| 7 | Use Estate Explorer to visualise the Oracle ADB (optional) | Manual |
| 8 | Integration of Azure Data Fabric with Oracle ADB (optional) | Partial |
| 9 | Enable Microsoft Entra ID Authentication on Oracle ADB (optional) | Fully Automatable |

### Aggregate Summary

| Category | Count | Percentage |
|---|---|---|
| Fully Automatable | 26 | ~43% |
| Partial | 18 | ~30% |
| Manual | 16 | ~27% |
| **Total** | **60** | **100%** |
