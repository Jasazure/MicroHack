# Reuse Catalog: Sovereign Cloud Platform Landing Zone Expansion

This catalog classifies assets from the Jasazure/MicroHack repository for reuse
in sovereign cloud platform landing zone expansion. Each item is assigned a
reuse pattern, a target module or workflow, and a priority level. Only findings
from INVENTORY.md and DEEP_DIVE_ANALYSIS.md are referenced.

---

## 1. Azure Policy and Governance

| File | Reuse Pattern | Landing Zone Module Target | Priority |
|---|---|---|---|
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/sovereign-cloud-initiative.json | ADAPT AND PARAMETERIZE | sovereign-policy-initiative.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/solution-01.md | EXTRACT PATTERN | sovereign-policy-initiative.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-03/solution-03.md | EXTRACT PATTERN | sovereign-policy-initiative.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-01.md | REFERENCE ONLY | sovereign-policy-initiative.bicep | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-03.md | REFERENCE ONLY | sovereign-policy-initiative.bicep | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/Readme.md | REFERENCE ONLY | sovereign-policy-initiative.bicep | LOW |

The sovereign-cloud-initiative.json file contains a four-policy initiative
(allowed locations, allowed locations for resource groups, require tag and
value, not allowed resource types) with hardcoded region names (norwayeast,
germanynorth, northeurope) and tag values (DataClassification=Sovereign). These
must be parameterized for production use. solution-01.md provides 29 CLI command
sequences covering policy assignments, remediation tasks, tag inheritance, and
compliance verification that can be extracted into reusable deployment scripts.
solution-03.md adds TLS enforcement policy (fe83a0eb) and diagnostic settings
patterns.

---

## 2. Encryption and Key Management

| File | Reuse Pattern | Landing Zone Module Target | Priority |
|---|---|---|---|
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-02/solution-02.md | EXTRACT PATTERN | sovereign-keyvault-cmk.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-03/solution-03.md | EXTRACT PATTERN | sovereign-storage-tls.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/solution-04.md | EXTRACT PATTERN | sovereign-keyvault-cmk.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/SECURITY/keyvault.bicep | ADAPT AND PARAMETERIZE | sovereign-keyvault-cmk.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/key-vault.tf | REFERENCE ONLY | sovereign-keyvault-cmk.bicep | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-02.md | REFERENCE ONLY | sovereign-keyvault-cmk.bicep | LOW |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-03.md | REFERENCE ONLY | sovereign-storage-tls.bicep | LOW |

solution-02.md contains CLI sequences for Key Vault creation with purge
protection, RSA-4096 CMK generation, storage account CMK configuration, and key
rotation. solution-04.md adds Key Vault with RBAC authorization and template
deployment flags. The BCDR keyvault.bicep module is the only existing Bicep
module for Key Vault in the repository and can be adapted with sovereign-specific
parameters (purge protection, RBAC authorization, enabled-for-deployment).

---

## 3. RBAC and Identity

| File | Reuse Pattern | Landing Zone Module Target | Priority |
|---|---|---|---|
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/subscription-preparations/3-rbac.ps1 | ADAPT AND PARAMETERIZE | deploy-sovereign-lz.yml | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/subscription-preparations/4-resource-groups.ps1 | ADAPT AND PARAMETERIZE | deploy-sovereign-lz.yml | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-01/solution-01.md | EXTRACT PATTERN | sovereign-rbac-roles.bicep | HIGH |
| 03-Azure/99-PreparationHelpers/Create Admin Users.ps1 | ADAPT AND PARAMETERIZE | deploy-sovereign-lz.yml | HIGH |
| 03-Azure/99-PreparationHelpers/Create MH Users.ps1 | REFERENCE ONLY | deploy-sovereign-lz.yml | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-02/solution-02.md | EXTRACT PATTERN | sovereign-rbac-roles.bicep | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/solution-04.md | EXTRACT PATTERN | sovereign-rbac-roles.bicep | MEDIUM |

3-rbac.ps1 assigns Security Reader and Resource Policy Contributor roles at
subscription scope using Entra ID group lookup. solution-01.md defines a custom
"Sovereign Compliance Auditor" RBAC role with read-only permissions for
resources, policy insights, consumption, cost management, and security. It also
creates SovereignOps and Compliance Officers Entra ID groups with scoped role
assignments. 4-resource-groups.ps1 assigns Owner, Key Vault Administrator, and
Storage Account Contributor roles. Create Admin Users.ps1 provisions 10 admin
accounts and 6 groups with subscription-level RBAC. All scripts require
parameterization of subscription IDs, group names, and role lists.

---

## 4. Confidential Compute

| File | Reuse Pattern | Landing Zone Module Target | Priority |
|---|---|---|---|
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/solution-04.md | EXTRACT PATTERN | sovereign-confidential-vm.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-05/solution-05.md | EXTRACT PATTERN | sovereign-confidential-aks.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-05/resources/cvm-attestation-pod.yaml | DIRECT REUSE | sovereign-confidential-aks.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-04/portal-guide.md | REFERENCE ONLY | sovereign-confidential-vm.bicep | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-05/portal-guide.md | REFERENCE ONLY | sovereign-confidential-aks.bicep | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-04.md | REFERENCE ONLY | sovereign-confidential-vm.bicep | LOW |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-05.md | REFERENCE ONLY | sovereign-confidential-aks.bicep | LOW |

solution-04.md contains CLI commands for deploying a Confidential VM
(Standard_DC2as_v6) with AMD SEV-SNP, vTPM, Secure Boot, and no public IP using
the Ubuntu 22.04 CVM image. It also covers Azure Attestation provider creation
and guest attestation client build and execution. solution-05.md covers AKS
cluster creation with a confidential VM node pool (Standard_DC2as_v5) and
attestation pod deployment. cvm-attestation-pod.yaml is directly reusable as a
Kubernetes pod manifest for CVM attestation verification with TPM device access
and confidential VM node selector.

---

## 5. Hybrid Arc and Azure Local

| File | Reuse Pattern | Landing Zone Module Target | Priority |
|---|---|---|---|
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/deploy-arcbox.ps1 | ADAPT AND PARAMETERIZE | deploy-sovereign-lz.yml | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/deploy-localbox.ps1 | ADAPT AND PARAMETERIZE | deploy-sovereign-lz.yml | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/walkthrough/challenge-06/solution-06.md | EXTRACT PATTERN | sovereign-arc-governance.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/subscription-preparations/1-resource-providers.ps1 | ADAPT AND PARAMETERIZE | deploy-sovereign-lz.yml | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/demo-vm-creator/README.md | REFERENCE ONLY | deploy-sovereign-lz.yml | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/challenges/challenge-06.md | REFERENCE ONLY | sovereign-arc-governance.bicep | LOW |

deploy-arcbox.ps1 deploys Azure Arc Jumpstart ArcBox for IT Pros via ARM
template from the microsoft/azure_arc repository. deploy-localbox.ps1 deploys
LocalBox for Azure Local simulation via Bicep templates. Both scripts have a
known bug (variable reference mismatch for $PlainPassword/$sshRSAPublicKey in
deploy-arcbox.ps1) that must be fixed before reuse. 1-resource-providers.ps1
registers 24 Azure resource providers including Microsoft.HybridCompute,
Microsoft.AzureStackHCI, Microsoft.ResourceConnector, and
Microsoft.Attestation. solution-06.md documents Machine Configuration policy
for SSH posture control on Arc-enabled servers, Defender for Cloud integration,
and Azure Update Manager.

---

## 6. BCDR and Monitoring

| File | Reuse Pattern | Landing Zone Module Target | Priority |
|---|---|---|---|
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/SITERECOVERY/asrvault.bicep | ADAPT AND PARAMETERIZE | sovereign-bcdr.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/MONITORING/monitor.bicep | ADAPT AND PARAMETERIZE | sovereign-monitoring.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/SITERECOVERY/automation.bicep | ADAPT AND PARAMETERIZE | sovereign-bcdr.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/NETWORK/vnet.bicep | ADAPT AND PARAMETERIZE | sovereign-networking.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/NETWORK/nsg.bicep | ADAPT AND PARAMETERIZE | sovereign-networking.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/BASTION/bastion.bicep | ADAPT AND PARAMETERIZE | sovereign-networking.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/MODULES/STORAGE/storage.bicep | ADAPT AND PARAMETERIZE | sovereign-storage-tls.bicep | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/deploy.json | REFERENCE ONLY | sovereign-bcdr.bicep | MEDIUM |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/setup.sh | EXTRACT PATTERN | deploy-sovereign-lz.yml | MEDIUM |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/validate-prerequisites.sh | EXTRACT PATTERN | deploy-sovereign-lz.yml | MEDIUM |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/ARM/template.json | REFERENCE ONLY | sovereign-monitoring.bicep | MEDIUM |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/terraform/enviornment/network.tf | REFERENCE ONLY | sovereign-networking.bicep | MEDIUM |
| 03-Azure/01-03-Infrastructure/07_Azure_Monitor/resources/scripts/challenge-5/create-custom-table.ps1 | EXTRACT PATTERN | sovereign-monitoring.bicep | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/cleanup/1-resource-groups.ps1 | ADAPT AND PARAMETERIZE | deploy-sovereign-lz.yml | MEDIUM |

The BCDR MicroHack provides the only production-quality Bicep modules in the
repository. asrvault.bicep and automation.bicep define Site Recovery vault and
Automation runbooks for DR orchestration. monitor.bicep defines Log Analytics
workspace resources. vnet.bicep, nsg.bicep, and bastion.bicep provide
foundational networking modules. All modules require parameterization for
sovereign region constraints and naming conventions. The sovereign cloud
solution-03.md contributes KQL queries for TLS version monitoring that feed
into the monitoring module.

---

## 7. Automation and CI/CD

| File | Reuse Pattern | Landing Zone Module Target | Priority |
|---|---|---|---|
| .github/workflows/pr-compliance-check.yml | ADAPT AND PARAMETERIZE | deploy-sovereign-lz.yml | HIGH |
| .github/scripts/check_file_structure.py | ADAPT AND PARAMETERIZE | deploy-sovereign-lz.yml | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/setup.sh | EXTRACT PATTERN | deploy-sovereign-lz.yml | HIGH |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/validate-prerequisites.sh | EXTRACT PATTERN | deploy-sovereign-lz.yml | HIGH |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/subscription-preparations/1-resource-providers.ps1 | ADAPT AND PARAMETERIZE | deploy-sovereign-lz.yml | MEDIUM |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/resources/subscription-preparations/2-vcpu-quotas.ps1 | ADAPT AND PARAMETERIZE | deploy-sovereign-lz.yml | MEDIUM |
| 03-Azure/01-03-Infrastructure/04_BCDR_Azure_Native/Infra/App1/deploy-lab.ps1 | EXTRACT PATTERN | deploy-sovereign-lz.yml | MEDIUM |
| .github/CODEOWNERS | DIRECT REUSE | deploy-sovereign-lz.yml | LOW |
| .github/ISSUE_TEMPLATE/bug.yaml | REFERENCE ONLY | deploy-sovereign-lz.yml | LOW |

pr-compliance-check.yml runs check_file_structure.py on pull requests affecting
MicroHack directories. Both can be adapted for sovereign landing zone module
structure validation. setup.sh orchestrates BCDR lab deployment with
prerequisites, parameters, and verification steps that provide a pattern for a
sovereign landing zone deployment workflow. validate-prerequisites.sh validates
Azure CLI installation, authentication, permissions, and required resource
providers, providing a reusable prerequisite check pattern.

---

## 8. Repository Structure and Templates

| File | Reuse Pattern | Landing Zone Module Target | Priority |
|---|---|---|---|
| 99-MicroHack-Template/Readme.md | ADAPT AND PARAMETERIZE | sovereign-lz-documentation | HIGH |
| 99-MicroHack-Template/walkthrough/challenge-01/solution-01.md | ADAPT AND PARAMETERIZE | sovereign-lz-documentation | HIGH |
| 99-MicroHack-Template/challenges/challenge-01.md | ADAPT AND PARAMETERIZE | sovereign-lz-documentation | HIGH |
| .github/CODEOWNERS | DIRECT REUSE | deploy-sovereign-lz.yml | MEDIUM |
| .github/ISSUE_TEMPLATE/bug.yaml | REFERENCE ONLY | sovereign-lz-documentation | MEDIUM |
| .github/ISSUE_TEMPLATE/featurerequest.yaml | REFERENCE ONLY | sovereign-lz-documentation | MEDIUM |
| 99-MicroHack-Template/challenges/finish.md | REFERENCE ONLY | sovereign-lz-documentation | LOW |
| 03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/img/Microsoft_Sovereign_Cloud.png | REFERENCE ONLY | sovereign-lz-documentation | LOW |

The MicroHack template provides a standardized directory structure
(challenges/, walkthrough/, resources/) with placeholder README sections
(introduction, context, objectives, prerequisites, challenges) that can be
adapted for sovereign landing zone module documentation. CODEOWNERS can be
directly reused to enforce code review ownership on sovereign module paths.

---

## Executive Summary

The repository contains a six-challenge Sovereign Cloud scenario with Azure CLI
sequences for policy initiatives, customer-managed key encryption, TLS
enforcement, confidential VM and AKS attestation, and hybrid Arc/Azure Local
governance. The BCDR MicroHack contributes Bicep modules for networking, Key
Vault, monitoring, and Site Recovery. PowerShell scripts provide RBAC
provisioning and resource provider registration patterns.

Overall reuse potential: **MEDIUM**. The repository provides extractable
CLI patterns and reference material for sovereign policy, encryption, and
confidential compute scenarios. However, the Sovereign Cloud directory contains
no Bicep or Terraform modules; all infrastructure is defined through imperative
CLI commands in markdown files. Only the BCDR directory contains declarative IaC.

Top three gaps that must be built from scratch:

1. **Sovereign Landing Zone Bicep Modules** -- No declarative IaC exists for
   sovereign policy initiatives, confidential compute, or Arc governance. All
   must be authored as parameterized Bicep modules.
2. **End-to-End Deployment Pipeline** -- No GitHub Actions workflow exists for
   sovereign landing zone deployment. A multi-stage pipeline with gates,
   approvals, and compliance validation must be created.
3. **Sovereign Compliance Reporting** -- No automated compliance dashboard or
   drift detection exists. KQL queries in solution-03.md provide a starting
   point but a complete alerting framework must be built.
