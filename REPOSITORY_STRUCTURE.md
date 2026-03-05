# Repository Structure Recommendation

## Section A — Annotated Directory Tree

The following directory tree shows the target structure for the sovereign
cloud platform landing zone repository.  It organises the seven sovereign
modules by functional domain under `modules/sovereign/`, places the
main orchestration template and per-environment parameter files under
`deployments/sovereign-baseline/`, and keeps the CI/CD workflow in
`.github/workflows/`.

```text
.
├── .github/
│   └── workflows/
│       └── deploy-sovereign-lz.yml            # Three-stage CI/CD pipeline
│                                              #   validate → what-if → deploy
│                                              #   Uses OIDC federation (no secrets)
│
├── deployments/
│   └── sovereign-baseline/                    # Orchestration layer
│       ├── main.bicep                         # Subscription-scoped entry point
│       │                                      #   Composes all 7 sovereign modules
│       │                                      #   Creates resource groups
│       │                                      #   Wires parameters across modules
│       ├── dev.parameters.json                # Development environment values
│       │                                      #   DoNotEnforce policy mode
│       │                                      #   Minimal compute (VM/AKS off)
│       └── prod.parameters.json               # Production environment values
│                                              #   Default (enforcing) policy mode
│                                              #   Same structure, production KV name
│
├── modules/
│   └── sovereign/                             # All sovereign landing zone modules
│       │
│       ├── policy/                            # ── Domain: Policy & Governance ──
│       │   └── sovereign-policy-initiative.bicep
│       │       # Subscription scope
│       │       # Custom policy initiative: allowed regions, mandatory
│       │       # tags, denied resource types, TLS baseline
│       │       # Inputs:  allowedLocations, mandatoryTagName/Value,
│       │       #          deniedResourceTypes, enforcementMode
│       │       # Outputs: initiativeId, assignmentId
│       │
│       ├── encryption/                        # ── Domain: Encryption & Key Mgmt ──
│       │   ├── sovereign-keyvault-cmk.bicep
│       │   │   # Resource-group scope
│       │   │   # Key Vault with purge protection, soft-delete (90 d),
│       │   │   # RBAC auth, optional private endpoint, diagnostics
│       │   │   # Inputs:  keyVaultName, skuName, privateEndpointSubnetId
│       │   │   # Outputs: keyVaultId, keyVaultUri
│       │   │
│       │   └── sovereign-tls-enforcement.bicep
│       │       # Subscription scope
│       │       # Three built-in policy assignments:
│       │       #   Storage (Deny), SQL (Audit), App Service (AuditIfNotExists)
│       │       # Inputs:  minimumTlsVersion, storageEffect, sqlEffect
│       │       # Outputs: storagePolicyAssignmentId, sqlPolicyAssignmentId,
│       │       #          appServicePolicyAssignmentId
│       │
│       ├── confidential-compute/              # ── Domain: Confidential Compute ──
│       │   ├── sovereign-confidential-vm.bicep
│       │   │   # Resource-group scope
│       │   │   # AMD SEV-SNP VM with Secure Boot, vTPM, managed
│       │   │   # identity, optional Guest Attestation extension
│       │   │   # Inputs:  vmName, vmSize (DC*as_v5/v6), subnetId,
│       │   │   #          sshPublicKey, attestationProviderUri
│       │   │   # Outputs: vmId, vmPrincipalId
│       │   │
│       │   └── sovereign-confidential-aks-nodepool.bicep
│       │       # Resource-group scope
│       │       # AKS agent pool with confidential VM SKU,
│       │       # taint (confidential=true:NoSchedule), labels,
│       │       # optional autoscaler
│       │       # Inputs:  aksClusterName, nodePoolName, vmSize,
│       │       #          nodeCount, enableAutoScaling
│       │       # Outputs: nodePoolId, nodePoolVmSize
│       │
│       ├── hybrid-arc/                        # ── Domain: Hybrid & Arc ──
│       │   └── sovereign-arc-governance.bicep
│       │       # Resource-group scope
│       │       # Machine Configuration prerequisites, SSH posture
│       │       # control, guest-config extension audit, Log Analytics
│       │       # workspace for compliance reporting
│       │       # Inputs:  enableSshPostureControl, includeArcServers,
│       │       #          enforcementMode
│       │       # Outputs: logAnalyticsWorkspaceId
│       │
│       └── identity/                          # ── Domain: Identity & RBAC ──
│           └── sovereign-rbac-assignments.bicep
│               # Subscription scope
│               # Loop-based RBAC assignments for SovereignOps group
│               # Defaults: Security Reader + Resource Policy Contributor
│               # Inputs:  sovereignOpsGroupObjectId, roleDefinitionIds
│               # Outputs: roleAssignmentIds, assignedRoles
│
├── 03-Azure/
│   └── 01-03-Infrastructure/
│       └── 01_Sovereign_Cloud/                # Original MicroHack content
│           ├── Readme.md                      #   Challenge overview (6 challenges)
│           ├── challenges/                    #   Hands-on challenge descriptions
│           ├── walkthrough/                   #   Step-by-step solutions & screenshots
│           ├── resources/                     #   PowerShell prep/cleanup scripts
│           ├── modules/                       #   Source Bicep module skeletons
│           └── img/                           #   Architecture diagrams
│
├── REPOSITORY_STRUCTURE.md                    # This file — annotated tree
├── INVENTORY.md                               # Full file-level inventory
├── REUSE_CATALOG.md                           # Asset-to-module mapping
├── CHALLENGES_ANALYSIS.md                     # Automation feasibility analysis
├── DEEP_DIVE_ANALYSIS.md                      # Per-file deep dive (in Sovereign dir)
├── README.md                                  # Repository root README
└── ...                                        # Other MicroHack content
```

## Section B — Module Composition & Data Flow

The `main.bicep` orchestration template deploys all seven modules in a single
subscription-scoped deployment.  The data flow between modules is:

```text
┌─────────────────────────────────────────────────────────┐
│  main.bicep  (targetScope = 'subscription')             │
│                                                         │
│  ┌──────────────────────┐  ┌──────────────────────────┐ │
│  │ 1. Policy Initiative │  │ 2. TLS Enforcement       │ │
│  │    (subscription)    │  │    (subscription)        │ │
│  └──────────────────────┘  └──────────────────────────┘ │
│                                                         │
│  ┌──────────────────────┐                               │
│  │ 3. RBAC Assignments  │                               │
│  │    (subscription)    │                               │
│  └──────────────────────┘                               │
│                                                         │
│  ┌─ workloadRg ─────────────────────────────────────┐   │
│  │ 4. Key Vault CMK                                 │   │
│  │ 5. Confidential VM        (optional, gated)      │   │
│  │ 6. AKS Node Pool          (optional, gated)      │   │
│  └──────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─ arcRg ──────────────────────────────────────────┐   │
│  │ 7. Arc Governance                                │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### Key design decisions

| Decision | Rationale |
|----------|-----------|
| Subscription-scoped entry point | Policy and RBAC assignments target the subscription; resource-group modules are deployed via `scope:` |
| Separate resource groups per domain | Workload resources (KV, VM, AKS) are isolated from governance resources (Arc, Log Analytics) |
| Optional VM and AKS toggles | Confidential compute resources are expensive; boolean gates prevent accidental deployment |
| DoNotEnforce for dev | Allows iterating on policy definitions without blocking resource creation during development |
| Module paths use `../../modules/` | Relative paths from `deployments/sovereign-baseline/` to the shared `modules/` directory |

## Section C — CI/CD Pipeline Integration

The existing `deploy-sovereign-lz.yml` workflow is wired to this structure:

| Workflow Reference | Repository Path |
|---|---|
| `az bicep lint --file deployments/sovereign-baseline/main.bicep` | `deployments/sovereign-baseline/main.bicep` |
| `az bicep build --file deployments/sovereign-baseline/main.bicep` | Compiles to `dist/sovereign-lz.json` |
| `deployments/sovereign-baseline/dev.parameters.json` | Dev parameter file (PRs, non-main branches) |
| `deployments/sovereign-baseline/prod.parameters.json` | Prod parameter file (push to main) |

### Pipeline stages

1. **Validate** — Lint + compile Bicep, validate ARM template at subscription scope
2. **What-If** — Preview deployment changes, post results as PR comment
3. **Deploy** — Apply to subscription (only on push to main or manual non-dry-run dispatch)

### Required GitHub secrets

| Secret | Purpose |
|--------|---------|
| `AZURE_CLIENT_ID` | Workload identity federation — app registration client ID |
| `AZURE_TENANT_ID` | Entra ID tenant |
| `AZURE_SUBSCRIPTION_ID` | Target subscription for sovereign landing zone |
