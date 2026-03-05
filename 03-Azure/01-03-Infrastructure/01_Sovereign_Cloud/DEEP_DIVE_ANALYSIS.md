# Deep-Dive Analysis: Sovereign Cloud MicroHack

This document provides a file-by-file deep-dive analysis of every file under `03-Azure/01-03-Infrastructure/01_Sovereign_Cloud/`. Each file is examined for its purpose, contents, dependencies, hardcoded values, Azure CLI commands, Azure Policy definitions, RBAC role assignments, and automation recommendations. The analysis is organized by challenge folder, with cross-references to the INVENTORY CHALLENGES_ANALYSIS automation feasibility ratings where applicable.

---

## General Files

### Readme.md

The top-level overview file for the Sovereign Cloud MicroHack. It introduces the concept of Sovereign Public and Private Cloud and outlines the core Azure services covered: Azure Policy, Role-Based Access Control (RBAC), encryption (at rest, in transit, and in use), confidential compute, Azure Arc, and Azure Local.

The MicroHack is structured into six challenges with the following estimated durations:

| Challenge | Topic | Estimated Duration |
|---|---|---|
| Challenge 1 | Enforce Sovereign Controls with Azure Policy and RBAC | 45 minutes |
| Challenge 2 | Encryption at Rest with Customer-Managed Keys | 30 minutes |
| Challenge 3 | Encryption in Transit -- Enforcing TLS | 30 minutes |
| Challenge 4 | Encryption in Use with Confidential Compute VM | 90-120 minutes |
| Challenge 5 | Encryption in Use with Confidential VMs in AKS | 90-120 minutes |
| Challenge 6 | Operating a Sovereign Hybrid Cloud with Azure Arc and Azure Local | 60-90 minutes |

**Contributors:** Thomas Maurer, Jan Egil Ring, Murali Rao Yelamanchili, Ye Zhang.

**Cost estimates:** Approximately $1000 for 50 users. This figure encompasses all Azure resources deployed across the six challenges including shared infrastructure (ArcBox, LocalBox) and per-user resources (VMs, storage accounts, Key Vaults, AKS clusters).

The file contains no CLI commands, no policy definitions, and no RBAC role assignments. It serves purely as documentation and navigation.

### challenges/finish.md

A completion summary and contributor listing displayed after all six challenges are finished. This file provides a wrap-up message and credits the contributors who developed the MicroHack content.

- No CLI commands or policy definitions.
- No RBAC role assignments.
- No automation considerations.

---

## Subscription Preparation Scripts

### resources/subscription-preparations/1-resource-providers.ps1

**Provisioning task:** Registers 24 Azure resource providers across all available subscriptions. This is a prerequisite step ensuring that the Azure services used throughout the MicroHack are available in the target subscriptions.

**Resource providers registered:**

- Microsoft.HybridCompute
- Microsoft.GuestConfiguration
- Microsoft.HybridConnectivity
- Microsoft.AzureArcData
- Microsoft.AzureStackHCI
- Microsoft.ResourceConnector
- Microsoft.HybridContainerService
- Microsoft.Compute
- Microsoft.ConfidentialLedger
- Microsoft.Security
- Microsoft.PolicyInsights
- Microsoft.Advisor
- Microsoft.OperationsManagement
- Microsoft.OperationalInsights
- Microsoft.Insights
- Microsoft.Monitor
- Microsoft.KeyVault
- Microsoft.ManagedIdentity
- Microsoft.Network
- Microsoft.Storage
- Microsoft.Attestation
- Microsoft.Kubernetes
- Microsoft.KubernetesConfiguration
- Microsoft.ContainerService
- Microsoft.ExtendedLocation

**Az module dependencies:** Az.Accounts, Az.Resources.

**Microsoft Graph module dependencies:** None.

**Required Azure RBAC permissions:** The caller must have `*/registerAction` or a role that includes `Microsoft.Authorization/*/action` at the subscription scope (typically Owner or a custom registration role).

**Hardcoded subscription IDs, tenant IDs, or resource names:** None. The script iterates over all subscriptions dynamically via `Get-AzSubscription`.

**Recommendation:** Wrap as a parameterized function accepting an optional `$SubscriptionIds` array parameter and an optional `$Providers` array parameter so callers can limit scope. Also suitable as a GitHub Actions step with `azure/login@v2` and `azure/powershell@v2` actions.

### resources/subscription-preparations/2-vcpu-quotas.ps1

**Provisioning task:** Checks current vCPU quota usage in a specified Azure region, calculates required quotas for running the MicroHack lab (ArcBox requires approximately 16-32 vCPUs, LocalBox requires approximately 48-64 vCPUs, Confidential VMs require additional vCPUs), and optionally submits quota increase requests via the Azure Quota REST API.

**Az module dependencies:** Az.Accounts, Az.Compute.

**Microsoft Graph module dependencies:** None.

**Required Azure RBAC permissions:** Reader (for quota read operations); quota increase requests require `Microsoft.Quota/quotas/write` (typically Owner or quota-specific roles).

**Hardcoded subscription IDs, tenant IDs, or resource names:** None. Subscription and region are provided interactively or via parameters. VM family names are hardcoded in the `$quotaNames` mapping (StandardDSv5Family, StandardDSv6Family, StandardDASv5Family, StandardDCasv5Family, StandardDCadsv5Family, StandardESv5Family) -- these are API constant names and appropriate to keep.

**Hardcoded values to note:**

- API version `2023-02-01` for the Quota REST API.
- Per-user vCPU requirement of 4 for total regional and 6 for DCasv5 family.
- Shared infrastructure baseline of 64 total + 32 DSv5 + 32 DSv6.

**Recommendation:** Wrap as a parameterized function with `-Region`, `-NumberOfLabUsers`, `-SubscriptionId` parameters. The quota calculation constants (per-user and shared) should be configurable. Suitable as a GitHub Actions workflow step.

### resources/subscription-preparations/3-rbac.ps1

**Provisioning task:** Looks up an Entra ID group by display name, then assigns "Security Reader" and "Resource Policy Contributor" built-in RBAC roles at subscription scope to that group. Designed for MicroHack coaches preparing pre-provisioned Azure subscriptions for lab participants.

**Az module dependencies:** Az.Accounts, Az.Resources.

**Microsoft Graph module dependencies:** Microsoft.Graph.Groups (for `Get-MgGroup`).

**Required Azure RBAC permissions:** User Access Administrator or Owner at subscription scope (for `New-AzRoleAssignment`). Microsoft Graph permission: `Group.Read.All` (for `Get-MgGroup`).

**Hardcoded subscription IDs, tenant IDs, or resource names:** Default group name "LabUsers" (parameterized). No hardcoded subscription or tenant IDs -- subscription is selected interactively or via parameter.

**Recommendation:** Wrap as a parameterized function accepting `-GroupName`, `-SubscriptionId`, and an optional `-Roles` array parameter. Suitable as a GitHub Actions step with `azure/login@v2` + `azure/powershell@v2`.

### resources/subscription-preparations/4-resource-groups.ps1

**Provisioning task:** Creates numbered resource groups (labuser-01, labuser-02, ...) and assigns Owner, Key Vault Administrator, and Storage Account Contributor roles to the corresponding lab user for each resource group.

**Az module dependencies:** Az.Accounts, Az.Resources.

**Microsoft Graph module dependencies:** None.

**Required Azure RBAC permissions:** Owner or User Access Administrator at subscription scope (for `New-AzRoleAssignment` and `New-AzResourceGroup`).

**Hardcoded subscription IDs, tenant IDs, or resource names:**

- Default subscription name "Micro-Hack-1" (parameterized).
- Default location "northeurope" (parameterized).
- Default prefix "labuser-" (parameterized).
- Default count 60 (parameterized).
- UPN suffix dynamically derived from the signed-in user's account.

**Recommendation:** Wrap as a parameterized function. The role assignment list (Owner, Key Vault Administrator, Storage Account Contributor) should be an array parameter. Suitable as a GitHub Actions step.

---

## Cleanup Scripts

### resources/cleanup/1-resource-groups.ps1

**Provisioning task:** Bulk-deletes resource groups matching a wildcard pattern (default `LabUser*`) across all available Azure subscriptions. Uses background jobs (`-AsJob`) for parallel deletion with progress monitoring.

**Az module dependencies:** Az.Accounts, Az.Resources.

**Microsoft Graph module dependencies:** None.

**Required Azure RBAC permissions:** Contributor or Owner at subscription scope (for `Remove-AzResourceGroup`).

**Hardcoded subscription IDs, tenant IDs, or resource names:** Default pattern `LabUser*` (parameterized). No hardcoded subscription IDs.

**Recommendation:** Wrap as a parameterized function accepting `-ResourceGroupPattern` and an optional `-SubscriptionIds` filter. Add a `-WhatIf` switch for dry-run previews. Suitable as a GitHub Actions workflow step for post-event cleanup.

---

## Demo VM Creator Scripts

### resources/demo-vm-creator/README.md

Documents ArcBox and LocalBox deployment for Challenge 6. Lists features, requirements, estimated costs, and step-by-step usage instructions.

**No Azure CLI commands** in fenced code blocks (only PowerShell invocation examples).

**No Azure Policy definitions.**

**No RBAC role assignments described inline** (references portal-based RBAC assignment with screenshots).

**PowerShell commands in code blocks:**

- `.\deploy-arcbox.ps1 -ResourceGroupName "rg-arcbox-shared" -Location "swedencentral"` -- Deploys ArcBox for IT Pros sandbox environment.
- `.\deploy-localbox.ps1 -ResourceGroupName "rg-localbox-shared" -Location "swedencentral"` -- Deploys LocalBox Azure Local simulation.

**RBAC role assignments described (portal-based with screenshots):**

1. Reader role assigned to LabUsers group on LocalBox resource group (scope: resource group, principal type: group).
2. Azure Stack HCI VM Contributor role assigned to LabUsers group on LocalBox resource group (scope: resource group, principal type: group).
3. Reader role assigned to LabUsers group on ArcBox resource group (scope: resource group, principal type: group).
4. User Access Administrator role assigned to LabUsers group on ArcBox resource group with condition "Allow user to assign all roles except privileged administrator roles" (scope: resource group, principal type: group).

### resources/demo-vm-creator/deploy-arcbox.ps1

**Provisioning task:** Deploys Azure Arc Jumpstart ArcBox for IT Pros environment using the official ARM template from github.com/microsoft/azure_arc. Creates a resource group, generates a JSON parameters file, and initiates a `--no-wait` deployment via `az deployment group create`.

**Az module dependencies:** None (uses Azure CLI, not Az PowerShell modules).

**Azure CLI dependency:** `az` command-line tool required.

**Required Azure RBAC permissions:** Contributor at subscription scope (for resource group creation and ARM deployment).

**Hardcoded subscription IDs, tenant IDs, or resource names:**

- Default location "swedencentral" (parameterized).
- Default admin username "arcdemo" (parameterized).
- Template URI `https://raw.githubusercontent.com/microsoft/azure_arc/main/azure_jumpstart_arcbox/ARM/azuredeploy.json` is hardcoded.
- Variables `$sshRSAPublicKey` and `$PlainPassword` are referenced in the parameters file but not properly defined from the `$WindowsAdminPassword` prompt -- **this is a bug**.

**Recommendation:** Fix the variable references (`$PlainPassword` should be `$WindowsAdminPassword`, `$sshRSAPublicKey` needs generation or a parameter). Wrap as a parameterized function. Suitable as a GitHub Actions workflow step.

### resources/demo-vm-creator/deploy-localbox.ps1

**Provisioning task:** Deploys Azure Arc Jumpstart LocalBox environment for Azure Local. Downloads the required Bicep templates from github.com/microsoft/azure_arc, creates a parameters file, and initiates a `--no-wait` deployment via `az deployment group create`. Retrieves Azure Local resource provider service principal ID and tenant ID dynamically.

**Az module dependencies:** None (uses Azure CLI).

**Azure CLI dependency:** `az` command-line tool required.

**Required Azure RBAC permissions:** Contributor at subscription scope (for resource group creation and ARM/Bicep deployment). Microsoft Graph permissions to read service principals (`az ad sp list`).

**Hardcoded subscription IDs, tenant IDs, or resource names:**

- Default location "swedencentral" (parameterized).
- Default admin username "arcdemo" (parameterized).
- Default AzureLocalInstanceLocation "westeurope" (parameterized with ValidateSet).
- Bicep template base URI `https://raw.githubusercontent.com/microsoft/azure_arc/main/azure_jumpstart_localbox/bicep` is hardcoded.
- List of 6 Bicep files to download is hardcoded.

**Recommendation:** Externalize the Bicep file list. Add validation for the AzureLocalInstanceLocation. Suitable as a GitHub Actions workflow step.

---

## Challenge-1: Enforce Sovereign Controls with Azure Policy and RBAC

### challenges/challenge-01.md

Describes the challenge goals: restrict deployments to EU sovereign regions, enforce tagging (DataClassification=Sovereign), block public IPs, create custom RBAC roles, review the compliance dashboard, and remediate non-compliant resources.

- No Azure CLI commands in fenced code blocks (challenge description only; all CLI commands are in the solution file).
- No Azure Policy definitions inline (referenced by learning resources).
- RBAC role assignments described: Custom compliance auditor role (concept only, details in solution).

**Cross-reference:** The CHALLENGES_ANALYSIS rates Challenge 1 steps as partially automatable -- policy assignments are fully automatable via CLI, but portal-based RBAC review and compliance dashboard review are manual.

### walkthrough/challenge-01/solution-01.md

**Estimated duration:** 45 minutes.

This is the most command-dense file in the entire MicroHack. It contains 29 distinct Azure CLI command sequences covering policy assignments, RBAC configuration, compliance verification, testing, remediation, and tag inheritance.

**Azure CLI commands extracted from fenced code blocks:**

1. **Azure CLI installation:**
   ```
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```
   Installs Azure CLI on Debian/Ubuntu systems running in WSL2.

2. **Variable setup block:**
   ```
   RESOURCE_GROUP="labuser-xx"
   ATTENDEE_ID="${RESOURCE_GROUP}"
   SUBSCRIPTION_ID="xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx"
   LOCATION="norwayeast"
   DISPLAY_PREFIX="Lab User-${ATTENDEE_ID#labuser-}"
   GROUP_PREFIX="Lab-User-${ATTENDEE_ID#labuser-}"
   ```
   Sets up environment variables for the participant; RESOURCE_GROUP, SUBSCRIPTION_ID, and LOCATION must be replaced with actual values.

3. **Allowed locations policy assignment:**
   ```
   az policy assignment create \
     --subscription "$SUBSCRIPTION_ID" \
     --name "$POLICY_NAME" \
     --display-name "$POLICY_DISPLAY_NAME" \
     --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" \
     --policy "$POLICY_DEFINITION_ID" \
     --params '{"listOfAllowedLocations":{"value":["norwayeast","germanynorth", "northeurope"]}}'
   ```
   Assigns the built-in "Allowed locations" policy (e56962a6-4747-49cd-b67b-bf8b01975c4c) to restrict resource deployments to Norway East, Germany North, and North Europe.

4. **Allowed locations for resource groups (audit-only):**
   ```
   az policy assignment create \
     --name "${ATTENDEE_ID}-restrict-rg-to-sovereign-regions" \
     --display-name "${DISPLAY_PREFIX} - Restrict Resource Groups to Sovereign Regions" \
     --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" \
     --policy "$RG_POLICY_DEFINITION_ID" \
     --params '{
       "listOfAllowedLocations": {
         "value": ["norwayeast", "germanynorth", "northeurope"]
       }
     }' \
   --enforcement-mode DoNotEnforce
   ```
   Assigns the built-in "Allowed locations for resource groups" policy (e765b5de-1225-4ba3-bd56-1ac6695af988) in audit-only mode.

5. **Require tag and value policy:**
   ```
   az policy assignment create \
     --name "$POLICY_NAME" \
     --display-name "$POLICY_DISPLAY_NAME" \
     --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" \
     --policy "$TAG_POLICY_DEFINITION_ID" \
     --params '{
       "tagName": {
         "value": "DataClassification"
       },
       "tagValue": {
         "value": "Sovereign"
       }
     }'
   ```
   Assigns the built-in "Require a tag and its value" policy (1e30110a-5ceb-460c-a204-c1c3969c6d62) requiring DataClassification=Sovereign on all resources.

6. **Flexible tag policy (alternative):**
   ```
   az policy assignment create \
     --name "$POLICY_NAME" \
     --display-name "$POLICY_DISPLAY_NAME" \
     --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" \
     --policy "$FLEXIBLE_TAG_POLICY" \
     --params '{
       "tagName": {
         "value": "DataClassification"
       }
     }'
   ```
   Alternative flexible tag policy (871b6d14-10aa-478d-b590-94f262ecfa99) requiring the DataClassification tag with any value.

7. **Storage public access policy search:**
   ```
   az policy definition list --query "[?displayName && contains(displayName, 'Storage') && contains(displayName, 'public')].{Name:displayName, ID:name}" -o table
   ```
   Lists Azure Policy definitions related to Storage public access to identify relevant policies.

8. **Storage disable public access:**
   ```
   az policy assignment create \
     --name "storage-disable-public-access" \
     --display-name "$POLICY_DISPLAY_NAME" \
     --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" \
     --policy "$STORAGE_PUBLIC_ACCESS_POLICY"
   ```
   Assigns the "Storage accounts should disable public network access" policy (34c877ad-507e-4c82-993e-3452a6e0ad3c).

9. **Block public IP addresses:**
   ```
   az policy assignment create \
     --name "$POLICY_NAME" \
     --display-name "$POLICY_DISPLAY_NAME" \
     --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" \
     --policy "$DENY_RESOURCE_TYPE_POLICY" \
     --params '{
       "listOfResourceTypesNotAllowed": {
         "value": ["Microsoft.Network/publicIPAddresses"]
       }
     }'
   ```
   Assigns the "Not allowed resource types" policy (6c112d4e-5bc7-47ae-a041-ea2d9dccd749) to block public IP address creation.

10. **Custom policy initiative creation:**
    ```
    az policy set-definition create \
      --name "${ATTENDEE_ID}-sovereign-cloud-baseline" \
      --display-name "${DISPLAY_PREFIX} - Sovereign Cloud Security Baseline" \
      --description "Enforce location, tagging, and network controls for sovereign workloads" \
      --definitions sovereign-cloud-initiative.json \
      --subscription "$SUBSCRIPTION_ID"
    ```
    Creates a custom policy initiative (set definition) combining location, tagging, and network controls into a single "Sovereign Cloud Security Baseline."

11. **Initiative assignment:**
    ```
    az policy assignment create \
      --name "${ATTENDEE_ID}-sovereign-baseline-assignment" \
      --display-name "${DISPLAY_PREFIX} - Sovereign Cloud Security Baseline" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" \
      --policy-set-definition "$INITIATIVE_ID"
    ```
    Assigns the custom sovereign cloud policy initiative at resource group scope.

12. **Entra ID group creation (SovereignOps):**
    ```
    az ad group create \
      --display-name "${GROUP_PREFIX}-SovereignOps-Team" \
      --mail-nickname "${GROUP_PREFIX}-SovereignOps"
    ```
    Creates an Entra ID security group for the SovereignOps team.

13. **Contributor role assignment:**
    ```
    az role assignment create \
      --assignee "$GROUP_OBJECT_ID" \
      --role "Contributor" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"
    ```
    Assigns the Contributor built-in role to the SovereignOps group at resource group scope.

14. **VM Contributor role assignment:**
    ```
    az role assignment create \
      --assignee "$GROUP_OBJECT_ID" \
      --role "Virtual Machine Contributor" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"
    ```
    Assigns the Virtual Machine Contributor role as a more granular alternative.

15. **Storage Account Contributor role assignment:**
    ```
    az role assignment create \
      --assignee "$GROUP_OBJECT_ID" \
      --role "Storage Account Contributor" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"
    ```
    Assigns the Storage Account Contributor role as a more granular alternative.

16. **Custom RBAC role creation:**
    ```
    az role definition create --role-definition compliance-auditor-role.json
    ```
    Creates a custom RBAC role "Sovereign Compliance Auditor" with read-only permissions for resources, policy insights, consumption, cost management, and security.

17. **Entra ID group creation (Compliance Officers):**
    ```
    az ad group create \
      --display-name "${GROUP_PREFIX}-Compliance-Officers" \
      --mail-nickname "${GROUP_PREFIX}-ComplianceOfficers"
    ```
    Creates an Entra ID security group for compliance officers.

18. **Custom role assignment:**
    ```
    az role assignment create \
      --assignee "$COMPLIANCE_GROUP_ID" \
      --role "${DISPLAY_PREFIX} - Sovereign Compliance Auditor" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"
    ```
    Assigns the custom Sovereign Compliance Auditor role to the compliance officers group at resource group scope.

19. **List custom roles:**
    ```
    az role definition list -g $RESOURCE_GROUP --custom-role-only true --query "[].{Name:roleName, Type:roleType}" -o table
    ```
    Lists custom RBAC roles assigned to the resource group for verification.

20. **Show custom role details:**
    ```
    az role definition list --name "${DISPLAY_PREFIX} - Sovereign Compliance Auditor" -o json
    ```
    Shows detailed permissions of the custom Sovereign Compliance Auditor role.

21. **Compliance state query:**
    ```
    az policy state list -g $RESOURCE_GROUP \
      --filter "policyAssignmentName eq '${ATTENDEE_ID}-restrict-rg-to-sovereign-regions'" \
      --query "[].{Resource:resourceId, State:complianceState, PolicyAssignmentName:policyAssignmentName}" \
      -o table
    ```
    Queries compliance state for the sovereign region restriction policy at resource group scope.

22. **Non-compliant summary:**
    ```
    az policy state summarize -g $RESOURCE_GROUP \
      --filter "complianceState eq 'NonCompliant'" \
      -o json
    ```
    Gets a summary of non-compliant resources in the resource group.

23. **Non-compliant resource listing:**
    ```
    az policy state list -g $RESOURCE_GROUP \
      --filter "complianceState eq 'NonCompliant'" \
      --query "[].{Resource:resourceId, PolicyAssignmentName:policyAssignmentName, Reason:complianceReasonCode}" \
      -o table
    ```
    Lists all non-compliant resources with policy assignment names and reason codes.

24. **Policy test commands (4 tests):**

    - **Test 1 -- Non-sovereign region (expected: denied):**
      ```
      az storage account create --name "teststoragewestus$RANDOM" --resource-group "$RESOURCE_GROUP" --location "westus" --sku Standard_LRS --tags DataClassification=Sovereign
      ```
      Attempts deployment to non-sovereign region.

    - **Test 2 -- Compliant deployment (expected: success):**
      ```
      az storage account create --name "$STORAGE_NAME" --resource-group "$RESOURCE_GROUP" --location "norwayeast" --sku Standard_LRS --tags DataClassification=Sovereign
      ```
      Creates a compliant storage account in Norway East with proper tags.

    - **Test 3 -- Missing tag (expected: denied):**
      ```
      az storage account create --name "testuntagged$RANDOM" --resource-group "$RESOURCE_GROUP" --location "norwayeast" --sku Standard_LRS
      ```
      Attempts deployment without required DataClassification tag.

    - **Test 4 -- Public IP creation (expected: denied):**
      ```
      az network public-ip create --name "test-public-ip" --resource-group "$RESOURCE_GROUP" --location "norwayeast" --tags DataClassification=Sovereign
      ```
      Attempts to create a public IP address.

25. **Remediation -- Custom tag policy definition:**
    ```
    az policy definition create \
      --name "${ATTENDEE_ID}-add-dataclassification-tag" \
      --display-name "${DISPLAY_PREFIX} - Add DataClassification Tag" \
      --description "Adds DataClassification=Sovereign tag if missing" \
      --rules add-tag-policy-rule.json \
      --params add-tag-policy-params.json \
      --mode Indexed \
      --subscription "$SUBSCRIPTION_ID"
    ```
    Creates a custom policy definition with Modify effect to add the DataClassification=Sovereign tag to resources missing it.

    **Remediation -- Policy assignment with managed identity:**
    ```
    az policy assignment create \
      --name "${ATTENDEE_ID}-add-tag-with-remediation" \
      --display-name "${DISPLAY_PREFIX} - Add DataClassification Tag with Remediation" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" \
      --policy "$POLICY_DEF_ID" \
      --location "norwayeast" \
      --assign-identity \
      --identity-scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" \
      --role "Contributor"
    ```
    Assigns the tag remediation policy with a system-assigned managed identity for automated tag application.

    **Remediation -- Create remediation task:**
    ```
    az policy remediation create \
      --name "${ATTENDEE_ID}-remediate-missing-tags" \
      --policy-assignment "${ATTENDEE_ID}-add-tag-with-remediation" \
      --resource-group "$RESOURCE_GROUP"
    ```
    Creates a remediation task to apply the DataClassification tag to existing resources missing it.

    **Remediation -- Check status:**
    ```
    az policy remediation show --name "${ATTENDEE_ID}-remediate-missing-tags" --resource-group "$RESOURCE_GROUP"
    ```
    Checks remediation task status.

    **Remediation -- List all tasks:**
    ```
    az policy remediation list --resource-group "$RESOURCE_GROUP" -o table
    ```
    Lists all remediation tasks in the resource group.

26. **Tag inheritance:**
    ```
    az policy assignment create \
      --name "${ATTENDEE_ID}-inherit-dataclassification-tag" \
      --display-name "${DISPLAY_PREFIX} - Inherit DataClassification Tag from RG" \
      --scope "/subscriptions/$SUBSCRIPTION_ID" \
      --policy "$TAG_INHERIT_POLICY" \
      --params '{"tagName": {"value": "DataClassification"}}' \
      --location "norwayeast" \
      --assign-identity \
      --identity-scope "/subscriptions/$SUBSCRIPTION_ID" \
      --role "Contributor"
    ```
    Assigns the built-in tag inheritance policy (cd3aa116-8754-49c9-a813-ad46512ece54) at subscription scope.

27. **Policy exemption:**
    ```
    az policy exemption create \
      --name "${ATTENDEE_ID}-test-exemption" \
      --display-name "${DISPLAY_PREFIX} - Test Resource Exemption" \
      --description "Temporary exemption for testing purposes" \
      --policy-assignment "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/microsoft.authorization/policyAssignments/${ATTENDEE_ID}-restrict-to-sovereign-regions" \
      --exemption-category "Waiver" \
      --expires "2026-3-28T23:59:59Z" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"
    ```
    Creates a time-limited policy exemption with Waiver category for the sovereign region restriction.

28. **Enforcement mode changes:**
    ```
    az policy assignment update --name "${ATTENDEE_ID}-require-data-classification-tag" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" --enforcement-mode DoNotEnforce
    ```
    Switches the tag requirement policy to audit-only mode for subsequent challenges.

    ```
    az policy assignment update --name "${ATTENDEE_ID}-block-public-ip-addresses" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" --enforcement-mode DoNotEnforce
    ```
    Switches the public IP block policy to audit-only mode for subsequent challenges.

29. **Validation commands:**
    ```
    az role assignment list --resource-group "$RESOURCE_GROUP" --query "[].{Principal:principalName, Role:roleDefinitionName}" -o table
    ```
    Lists all RBAC role assignments in the resource group for validation.

    ```
    az role definition list --name "${DISPLAY_PREFIX} - Sovereign Compliance Auditor" --query "[].roleName" -o tsv
    ```
    Verifies the custom compliance auditor role exists.

    ```
    az policy remediation list --resource-group "$RESOURCE_GROUP" -o table
    ```
    Verifies remediation task completion status.

    ```
    az resource list --resource-group "$RESOURCE_GROUP" --query "[].{Name:name, Tags:tags}" -o json
    ```
    Verifies resources have required tags after remediation.

**Azure Policy definition JSON fragments found:**

1. **Sovereign Cloud Initiative** (also in separate sovereign-cloud-initiative.json file):
   - Policy e56962a6-4747-49cd-b67b-bf8b01975c4c: "Allowed locations" -- restricts resource locations to norwayeast, germanynorth, northeurope.
   - Policy e765b5de-1225-4ba3-bd56-1ac6695af988: "Allowed locations for resource groups" -- restricts resource group locations to norwayeast, germanynorth, northeurope.
   - Policy 1e30110a-5ceb-460c-a204-c1c3969c6d62: "Require a tag and its value" -- requires DataClassification=Sovereign tag.
   - Policy 6c112d4e-5bc7-47ae-a041-ea2d9dccd749: "Not allowed resource types" -- blocks Microsoft.Network/publicIPAddresses.

2. **Custom "Sovereign Compliance Auditor" role definition:**
   - Actions: `*/read`, `Microsoft.PolicyInsights/policyStates/queryResults/action`, `Microsoft.PolicyInsights/policyEvents/queryResults/action`, `Microsoft.PolicyInsights/policyTrackedResources/queryResults/read`, `Microsoft.Consumption/*/read`, `Microsoft.CostManagement/*/read`, `Microsoft.Security/*/read`.
   - AssignableScopes: `/subscriptions/{{SUBSCRIPTION_ID}}/resourceGroups/{{RESOURCE_GROUP}}` (template placeholders).

3. **Tag remediation policy rule (add-tag-policy-rule.json):**
   - Condition: checks if tag parameter does not exist on resource.
   - Effect: modify -- adds the tag with specified value.
   - roleDefinitionIds: b24988ac-6180-42a0-ab88-20f7382dd24c (Contributor).

4. **Tag remediation policy parameters (add-tag-policy-params.json):**
   - tagName: String, default "DataClassification".
   - tagValue: String, default "Sovereign".

**RBAC role assignments described in solution-01.md:**

1. Contributor role to SovereignOps-Team group at resource group scope (principal type: group).
2. Virtual Machine Contributor role to SovereignOps-Team group at resource group scope (principal type: group).
3. Storage Account Contributor role to SovereignOps-Team group at resource group scope (principal type: group).
4. Custom "Sovereign Compliance Auditor" role to Compliance-Officers group at resource group scope (principal type: group).
5. Contributor role to tag remediation policy managed identity at resource group scope (principal type: managed identity, via --assign-identity).

### walkthrough/challenge-01/sovereign-cloud-initiative.json

Contains an Azure Policy initiative (policy set) definition with 4 policy definitions:

1. **Allowed locations** (e56962a6-4747-49cd-b67b-bf8b01975c4c): Restricts resource locations to norwayeast, germanynorth, northeurope.
2. **Allowed locations for resource groups** (e765b5de-1225-4ba3-bd56-1ac6695af988): Restricts resource group locations to norwayeast, germanynorth, northeurope.
3. **Require a tag and its value** (1e30110a-5ceb-460c-a204-c1c3969c6d62): Requires DataClassification=Sovereign.
4. **Not allowed resource types** (6c112d4e-5bc7-47ae-a041-ea2d9dccd749): Blocks Microsoft.Network/publicIPAddresses.

**Hardcoded values:** Region names (norwayeast, germanynorth, northeurope), tag name "DataClassification", tag value "Sovereign", resource type "Microsoft.Network/publicIPAddresses". These are intentional for the sovereign scenario but should be parameterized for reuse.

---

## Challenge-2: Encryption at Rest with Customer-Managed Keys

### challenges/challenge-02.md

Describes the challenge goals: deploy Key Vault with purge protection, implement customer-managed keys (CMK) for Azure Storage, and verify encryption settings.

- No Azure CLI commands (challenge description only).
- No Azure Policy definitions.
- No RBAC role assignments.

### walkthrough/challenge-02/solution-02.md

**Estimated duration:** 30 minutes.

**Azure CLI commands extracted from fenced code blocks:**

1. **Azure CLI installation:**
   ```
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```
   Installs Azure CLI on Debian/Ubuntu systems.

2. **Variable setup:**
   ```
   RESOURCE_GROUP="labuser-xx"
   SUBSCRIPTION_ID="xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx"
   LOCATION="norwayeast"
   ```
   Sets environment variables for participant; all three must be replaced.

3. **Resource group creation:**
   ```
   az group create -n $RESOURCE_GROUP -l $LOCATION
   ```
   Creates the participant's resource group (if not pre-provisioned).

4. **Hash suffix generation:**
   ```
   HASH_SUFFIX=$(echo -n "${RESOURCE_GROUP}-${RANDOM}-${RANDOM}" | md5sum | cut -c1-8)
   ```
   Generates a unique 8-character hash suffix for globally unique resource names.

5. **Key Vault creation:**
   ```
   az keyvault create \
     -n $KEYVAULT_NAME \
     -g $RESOURCE_GROUP \
     -l $LOCATION \
     --enable-purge-protection true \
     --sku standard
   ```
   Creates a Key Vault with purge protection enabled and standard SKU for CMK storage.

6. **Key Vault Crypto Officer role assignment:**
   ```
   CURRENT_USER_ID=$(az ad signed-in-user show --query id -o tsv)
   az role assignment create \
     --role "Key Vault Crypto Officer" \
     --assignee $CURRENT_USER_ID \
     --scope $(az keyvault show --name $KEYVAULT_NAME --resource-group $RESOURCE_GROUP --query id -o tsv)
   ```
   Assigns Key Vault Crypto Officer role to the current user for key management operations.

7. **Key generation:**
   ```
   az keyvault key create \
     --vault-name $KEYVAULT_NAME \
     --name cmk-storage-rsa-4096 \
     --kty RSA \
     --size 4096
   ```
   Generates a 4096-bit RSA key in Key Vault for customer-managed encryption.

8. **Key import (alternative):**
   ```
   az keyvault key import \
     --vault-name $KEYVAULT_NAME \
     --name cmk-storage-imported \
     --file /path/to/key.pem
   ```
   Imports an existing PEM key into Key Vault.

9. **Storage account creation:**
   ```
   az storage account create \
     -n $STORAGEACCOUNT_NAME \
     -g $RESOURCE_GROUP \
     -l $LOCATION \
     --sku Standard_GRS \
     --kind StorageV2 \
     --https-only true
   ```
   Creates a StorageV2 account with geo-redundant storage and HTTPS-only enforcement.

10. **Enable managed identity:**
    ```
    az storage account update -n $STORAGEACCOUNT_NAME -g $RESOURCE_GROUP --assign-identity
    ```
    Enables system-assigned managed identity on the storage account for Key Vault authentication.

11. **Key Vault Crypto Service Encryption User role:**
    ```
    az role assignment create \
      --assignee $STORAGEACCOUNT_PRINCIPAL_ID \
      --role "Key Vault Crypto Service Encryption User" \
      --scope "${KV_SCOPE}"
    ```
    Assigns Key Vault Crypto Service Encryption User role to the storage account's managed identity for wrap/unwrap key operations.

12. **Configure CMK encryption:**
    ```
    az storage account update \
      -n $STORAGEACCOUNT_NAME \
      -g $RESOURCE_GROUP \
      --encryption-key-source Microsoft.Keyvault \
      --encryption-key-name $KEY_NAME \
      --encryption-key-version $KEY_VERSION \
      --encryption-key-vault https://$KEYVAULT_NAME.vault.azure.net/
    ```
    Configures the storage account to use the customer-managed key from Key Vault for encryption at rest.

13. **Verify encryption configuration:**
    ```
    az storage account show -n $STORAGEACCOUNT_NAME -g $RESOURCE_GROUP --query "encryption"
    ```
    Validates the encryption configuration shows Microsoft.Keyvault as key source.

14. **Key rotation:**
    ```
    az keyvault key rotate --vault-name $KEYVAULT_NAME --name cmk-storage-rsa-4096
    ```
    Rotates the CMK key, creating a new version.

**Azure Policy definitions:** None.

**RBAC role assignments described:**

1. Key Vault Crypto Officer to current user at Key Vault scope (principal type: user).
2. Key Vault Crypto Service Encryption User to storage account managed identity at Key Vault scope (principal type: service principal/managed identity).

---

## Challenge-3: Encryption in Transit -- Enforcing TLS

### challenges/challenge-03.md

Describes the challenge goals: enforce HTTPS on storage accounts, enforce TLS 1.2 minimum version, apply Azure Policy for TLS enforcement, and monitor TLS usage via Log Analytics and KQL queries.

- No Azure CLI commands (challenge description only).
- No Azure Policy definitions inline.

### walkthrough/challenge-03/solution-03.md

**Estimated duration:** 30 minutes.

**Azure CLI commands extracted from fenced code blocks:**

1. **Azure CLI installation:**
   ```
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```
   Installs Azure CLI.

2. **Variable setup:**
   ```
   RESOURCE_GROUP="labuser-xx"
   SUBSCRIPTION_ID="xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx"
   LOCATION="norwayeast"
   STORAGEACCOUNT_NAME="yourStorageAccountName"
   ```
   Sets environment variables; all must be replaced with actual values.

3. **Enable secure transfer:**
   ```
   az storage account update -g $RESOURCE_GROUP -n $STORAGEACCOUNT_NAME --https-only true
   ```
   Enables secure transfer (HTTPS only) on the storage account, rejecting HTTP requests.

4. **TLS minimum version policy assignment:**
   ```
   az policy assignment create \
     --name enforce-storage-min-tls12 \
     --display-name "Enforce storage min TLS 1.2" \
     --policy fe83a0eb-a853-422d-aac2-1bffd182c5d0 \
     --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP \
     --params '{ "effect": { "value": "Deny" }, "minimumTlsVersion": { "value": "TLS1_2" } }'
   ```
   Assigns the built-in "Storage accounts should have the specified minimum TLS version" policy with Deny effect, enforcing TLS 1.2 minimum.

5. **Log Analytics workspace creation:**
   ```
   LOG_ANALYTICS_WORKSPACE=law-$RESOURCE_GROUP
   az monitor log-analytics workspace create --resource-group $RESOURCE_GROUP --workspace-name $LOG_ANALYTICS_WORKSPACE
   ```
   Creates a Log Analytics workspace for collecting storage diagnostic logs.

6. **Storage account ID retrieval:**
   ```
   STORAGE_ACCOUNT_ID=$(az storage account show --name $STORAGEACCOUNT_NAME --resource-group $RESOURCE_GROUP --query id --output tsv)
   ```
   Retrieves the storage account resource ID.

7. **Log Analytics workspace ID retrieval:**
   ```
   LOG_ANALYTICS_WORKSPACE_ID=$(az monitor log-analytics workspace show --resource-group $RESOURCE_GROUP --workspace-name $LOG_ANALYTICS_WORKSPACE --query id --output tsv)
   ```
   Retrieves the Log Analytics workspace resource ID.

8. **Diagnostic settings creation:**
   ```
   az monitor diagnostic-settings create \
     --name blob-tls-insights \
     --resource ${STORAGE_ACCOUNT_ID}/blobServices/default \
     --workspace $LOG_ANALYTICS_WORKSPACE_ID \
     --logs '[{"category": "StorageRead", "enabled": true}, {"category": "StorageWrite", "enabled": true}]'
   ```
   Creates diagnostic settings to send blob read/write logs to Log Analytics for TLS version monitoring.

9. **Storage Blob Data Contributor role assignment:**
   ```
   CURRENT_USER_ID=$(az ad signed-in-user show --query id --output tsv)
   az role assignment create \
     --role "Storage Blob Data Contributor" \
     --assignee $CURRENT_USER_ID \
     --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGEACCOUNT_NAME
   ```
   Grants the current user Storage Blob Data Contributor role for blob upload/download operations.

10. **Blob container creation:**
    ```
    az storage container create \
      --name test-container \
      --account-name $STORAGEACCOUNT_NAME \
      --auth-mode login
    ```
    Creates a blob container using Entra ID authentication for testing.

**KQL queries found:**

```kusto
StorageBlobLogs
| where TimeGenerated > ago(1d)
| summarize requests = count() by TlsVersion
```
Summarizes blob storage requests by TLS version over the past 24 hours.

```kusto
StorageBlobLogs
| where TimeGenerated > ago(1d)
| where TlsVersion !in ("TLS 1.2","TLS 1.3")
| project TimeGenerated, TlsVersion, CallerIpAddress, UserAgentHeader, OperationName
| sort by TimeGenerated desc
```
Identifies client requests using TLS versions below 1.2 with caller details for remediation.

**Azure Policy definitions:**

1. Policy fe83a0eb-a853-422d-aac2-1bffd182c5d0: "Storage accounts should have the specified minimum TLS version" -- enforces TLS 1.2 minimum with Deny effect.

**RBAC role assignments described:**

1. Storage Blob Data Contributor to current user at storage account scope (principal type: user).

---

## Challenge-4: Encryption in Use with Confidential Compute VM

### challenges/challenge-04.md

Describes the challenge goals: create Key Vault, generate SSH keys, deploy Attestation Provider, create VNet with subnets, deploy a Confidential VM with AMD SEV-SNP, set up Azure Bastion for secure access, and review attestation token output.

- No Azure CLI commands (challenge description only).
- No Azure Policy definitions.

### walkthrough/challenge-04/solution-04.md

**Estimated duration:** 90-120 minutes.

**Azure CLI commands extracted from fenced code blocks:**

1. **Variable setup:**
   ```
   RESOURCE_GROUP="labuser-xx"
   ATTENDEE_ID="${RESOURCE_GROUP}"
   HASH_SUFFIX=$(echo -n "${ATTENDEE_ID}-${RANDOM}-${RANDOM}" | md5sum | cut -c1-8)
   LOCATION="northeurope"
   ADMIN_USERNAME="azureuser"
   KEYVAULT_NAME="kv-cc-${HASH_SUFFIX}"
   SSH_KEY_NAME="cc-${ATTENDEE_ID}-key"
   ATTESTATION_NAME="attest${HASH_SUFFIX}"
   ```
   Sets up environment variables with hash-based suffixes for globally unique resource names.

2. **Key Vault creation (with RBAC and template deployment):**
   ```
   az keyvault create \
     --name $KEYVAULT_NAME \
     --resource-group $RESOURCE_GROUP \
     --location $LOCATION \
     --sku standard \
     --enable-rbac-authorization true \
     --enabled-for-deployment true \
     --enabled-for-template-deployment true
   ```
   Creates a Key Vault with RBAC authorization model and template deployment support.

3. **Key Vault Secrets Officer role assignment:**
   ```
   CURRENT_USER_ID=$(az ad signed-in-user show --query id -o tsv)
   az role assignment create \
     --role "Key Vault Secrets Officer" \
     --assignee $CURRENT_USER_ID \
     --scope $(az keyvault show --name $KEYVAULT_NAME --resource-group $RESOURCE_GROUP --query id -o tsv)
   ```
   Assigns Key Vault Secrets Officer role to current user for SSH key storage.

4. **SSH key generation and Key Vault storage:**
   ```
   SSH_TEMP_FILE="/tmp/cc_ssh_key_${ATTENDEE_ID}_${RANDOM}"
   ssh-keygen -t rsa -b 4096 -f "$SSH_TEMP_FILE" -N "" -C "microhack-cc"
   az keyvault secret set --vault-name $KEYVAULT_NAME --name "ssh-private-key" --file "$SSH_TEMP_FILE"
   az keyvault secret set --vault-name $KEYVAULT_NAME --name "ssh-public-key" --file "${SSH_TEMP_FILE}.pub"
   SSH_PUBLIC_KEY=$(cat "${SSH_TEMP_FILE}.pub")
   rm -f "$SSH_TEMP_FILE" "${SSH_TEMP_FILE}.pub"
   ```
   Generates a 4096-bit RSA SSH key pair, stores both keys in Key Vault as secrets, and removes local temporary files.

5. **Attestation provider creation:**
   ```
   az attestation create \
     --name $ATTESTATION_NAME \
     --resource-group $RESOURCE_GROUP \
     --location $LOCATION
   ```
   Creates a Microsoft Azure Attestation provider for verifying TEE integrity.

6. **Virtual network creation:**
   ```
   az network vnet create \
     --resource-group $RESOURCE_GROUP \
     --name "vm-ubuntu-cvm-vnet" \
     --location $LOCATION \
     --address-prefix "10.10.0.0/24" \
     --subnet-name "vm-subnet" \
     --subnet-prefix "10.10.0.0/26"
   ```
   Creates a virtual network with a VM subnet.

7. **Bastion subnet creation:**
   ```
   az network vnet subnet create \
     --resource-group $RESOURCE_GROUP \
     --vnet-name "vm-ubuntu-cvm-vnet" \
     --name "AzureBastionSubnet" \
     --address-prefix "10.10.0.64/26"
   ```
   Creates the AzureBastionSubnet required for Azure Bastion deployment.

8. **Confidential VM creation:**
   ```
   az vm create \
     --resource-group $RESOURCE_GROUP \
     --name "vm-ubuntu-cvm" \
     --location $LOCATION \
     --size "Standard_DC2as_v6" \
     --admin-username $ADMIN_USERNAME \
     --ssh-key-value "$SSH_PUBLIC_KEY" \
     --authentication-type ssh \
     --enable-vtpm true \
     --image "Canonical:0001-com-ubuntu-confidential-vm-jammy:22_04-lts-cvm:latest" \
     --security-type "ConfidentialVM" \
     --os-disk-security-encryption-type "VMGuestStateOnly" \
     --enable-secure-boot true \
     --vnet-name "vm-ubuntu-cvm-vnet" \
     --subnet "vm-subnet" \
     --public-ip-address ""
   ```
   Creates a Confidential VM with AMD SEV-SNP, vTPM, Secure Boot, no public IP, using Ubuntu 22.04 CVM image on a Standard_DC2as_v6 size.

9. **Enable managed identity on VM:**
   ```
   az vm identity assign --resource-group $RESOURCE_GROUP --name "vm-ubuntu-cvm"
   ```
   Enables system-assigned managed identity on the Confidential VM.

10. **Bastion public IP creation:**
    ```
    az network public-ip create \
      --resource-group $RESOURCE_GROUP \
      --name "bastion-ip" \
      --location $LOCATION \
      --sku "Standard" \
      --allocation-method "Static"
    ```
    Creates a Standard SKU static public IP for Azure Bastion.

11. **Azure Bastion creation:**
    ```
    az network bastion create \
      --resource-group $RESOURCE_GROUP \
      --name "bastion" \
      --location $LOCATION \
      --vnet-name "vm-ubuntu-cvm-vnet" \
      --public-ip-address "bastion-ip" \
      --sku "Basic"
    ```
    Creates an Azure Bastion (Basic SKU) for secure SSH access without VM public IP.

12. **On-VM commands (run inside the Confidential VM via Bastion):**

    **Install build dependencies:**
    ```
    sudo -E apt-get update -y
    sudo -E apt-get upgrade -y
    sudo -E apt-get install -y build-essential libcurl4-openssl-dev libjsoncpp-dev libboost-all-dev nlohmann-json3-dev cmake wget git jq
    ```
    Installs build dependencies for the attestation client application.

    **Clone attestation repository:**
    ```
    git clone https://github.com/Azure/confidential-computing-cvm-guest-attestation.git
    ```
    Clones the Microsoft Azure Confidential Computing guest attestation repository.

    **Install guest attestation package:**
    ```
    wget https://packages.microsoft.com/repos/azurecore/pool/main/a/azguestattestation1/azguestattestation1_1.1.2_amd64.deb
    sudo dpkg -i azguestattestation1_1.1.2_amd64.deb
    ```
    Downloads and installs the Azure guest attestation package (version 1.1.2).

    **Build attestation client:**
    ```
    cd confidential-computing-cvm-guest-attestation/cvm-attestation-sample-app/
    cmake .
    make
    ```
    Builds the attestation client sample application from source.

    **Retrieve attestation URI:**
    ```
    ATTESTATION_URI=$(az attestation show --name $ATTESTATION_NAME --resource-group $RESOURCE_GROUP --query "attestUri" -o tsv)
    ```
    Retrieves the attestation provider URI.

    **Run attestation and decode JWT:**
    ```
    sudo ./AttestationClient -a $ATTESTATION_URI -o token | jq -R 'split(".") | .[0],.[1] | @base64d | fromjson'
    ```
    Runs the attestation client to get a JWT token from the custom attestation provider and decodes it for inspection.

**Azure Policy definitions:** None.

**RBAC role assignments described:**

1. Key Vault Secrets Officer to current user at Key Vault scope (principal type: user).

### walkthrough/challenge-04/portal-guide.md

Alternative portal-based walkthrough for Challenge 4. Covers the same scenario context and learning objectives as solution-04.md but uses Azure Portal UI steps with screenshots instead of CLI commands.

- No Azure CLI commands (portal-based steps use screenshots and UI instructions).
- No Azure Policy definitions.
- No RBAC role assignment CLI commands (RBAC is configured through the portal UI).

This file is useful for participants who prefer a visual, portal-driven workflow. The end result is identical to the CLI-based solution.

---

## Challenge-5: Encryption in Use with Confidential VMs in AKS

### challenges/challenge-05.md

Describes the challenge goals: create an AKS cluster, add a confidential VM node pool using AMD SEV-SNP capable VM sizes, verify configuration, and run an attestation sample to validate the TEE environment.

- No Azure CLI commands (challenge description only).
- No Azure Policy definitions.

### walkthrough/challenge-05/solution-05.md

**Estimated duration:** 90-120 minutes.

**Azure CLI commands extracted from fenced code blocks:**

1. **Variable setup:**
   ```
   RESOURCE_GROUP="labuser-xx"
   ATTENDEE_ID="${RESOURCE_GROUP}"
   HASH_SUFFIX=$(echo -n "$ATTENDEE_ID-$(date +%s)-$RANDOM" | md5sum | cut -c1-6)
   LOCATION="northeurope"
   AKS_CLUSTER_NAME="aks-cvmcluster$HASH_SUFFIX"
   DNS_LABEL="cvmcluster$HASH_SUFFIX"
   ADMIN_USERNAME="azureuser"
   KEYVAULT_NAME="kv-cc-${HASH_SUFFIX}"
   SSH_KEY_NAME="cc-${ATTENDEE_ID}-key"
   ATTESTATION_NAME="attest${HASH_SUFFIX}"
   ```
   Sets environment variables with hash suffix for unique AKS cluster and resource names.

2. **AKS preview extension:**
   ```
   az extension add --name aks-preview
   az extension update --name aks-preview
   ```
   Installs/updates the AKS preview CLI extension required for confidential VM node pool support.

3. **Feature flag registration:**
   ```
   az feature register --namespace "Microsoft.ContainerService" --name "AzureLinuxCVMPreview"
   ```
   Registers the AzureLinuxCVMPreview feature flag for confidential VM support in AKS.

4. **Feature status verification:**
   ```
   az feature show --namespace Microsoft.ContainerService --name AzureLinuxCVMPreview
   ```
   Verifies the registration status of the AzureLinuxCVMPreview feature.

5. **Provider re-registration:**
   ```
   az provider register --namespace Microsoft.ContainerService
   ```
   Refreshes the ContainerService resource provider registration.

6. **AKS cluster creation:**
   ```
   az aks create --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME --node-count 1 --location $LOCATION --generate-ssh-keys --node-vm-size Standard_D2s_v5
   ```
   Creates an AKS cluster with a single standard node (Standard_D2s_v5) as the system node pool.

7. **Get AKS credentials:**
   ```
   az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME
   ```
   Downloads AKS credentials and configures kubectl context.

8. **Add confidential node pool:**
   ```
   az aks nodepool add --resource-group $RESOURCE_GROUP --cluster-name $AKS_CLUSTER_NAME --name cvmnodepool --node-count 1 --node-vm-size Standard_DC2as_v5
   ```
   Adds a confidential VM node pool using Standard_DC2as_v5 (AMD SEV-SNP) with one node.

9. **Verify node pool VM size:**
   ```
   az aks nodepool show --resource-group $RESOURCE_GROUP --cluster-name $AKS_CLUSTER_NAME --name cvmnodepool --query 'vmSize'
   ```
   Verifies the confidential node pool is using the correct VM size.

10. **Check node image version:**
    ```
    az aks nodepool list --resource-group $RESOURCE_GROUP --cluster-name $AKS_CLUSTER_NAME --query "[?name=='cvmnodepool'].nodeImageVersion" -o tsv
    ```
    Retrieves the node image version of the confidential VM node pool.

11. **Deploy attestation pod:**
    ```
    kubectl apply -f cvm-attestation-pod.yaml
    ```
    Deploys the attestation verification pod to the AKS cluster.

12. **Check pod status:**
    ```
    kubectl get pods
    ```
    Checks the status of the attestation pod.

13. **Retrieve attestation logs:**
    ```
    kubectl logs cvm-attestation
    ```
    Retrieves attestation report containing JWT tokens with confidential computing verification data.

14. **Cleanup:**
    ```
    az group delete --name $RESOURCE_GROUP --yes --no-wait
    ```
    Deletes all resources in the resource group for cleanup.

**Azure Policy definitions:** None.

**RBAC role assignments:** None explicitly described.

### walkthrough/challenge-05/resources/cvm-attestation-pod.yaml

Defines a Kubernetes Pod specification for CVM attestation testing.

**Key configuration details:**

| Field | Value |
|---|---|
| Image | mcr.microsoft.com/acc/samples/cvm-attestation:1.1 |
| Volume mounts | /sys/kernel/security (TCG security filesystem), /dev/tpmrm0 (TPM resource manager device) |
| Security context | privileged=true (required for TPM access) |
| Node selector | kubernetes.azure.com/security-type=ConfidentialVM |
| Restart policy | Never (one-shot attestation verification) |

**Hardcoded values:** Image tag "1.1", host paths `/sys/kernel/security` and `/dev/tpmrm0` (these are standard Linux paths and appropriate to keep).

The privileged security context is necessary for the pod to access the TPM device and security filesystem on the host node. The node selector ensures the pod is scheduled exclusively on confidential VM nodes in the cluster.

### walkthrough/challenge-05/portal-guide.md

Alternative portal-based walkthrough for Challenge 5. Provides Azure Portal steps for creating the AKS cluster and adding confidential node pools, covering the same scenario context and learning objectives as solution-05.md.

Contains `kubectl` commands that are identical to those in solution-05.md (kubectl apply, get pods, logs). The portal guide defers to CLI for Kubernetes operations since there is no portal equivalent for pod deployment.

---

## Challenge-6: Operating a Sovereign Hybrid Cloud with Azure Arc and Azure Local

### challenges/challenge-06.md

Describes the challenge goals: explore ArcBox and LocalBox hybrid environments, assign Azure Policy with Machine Configuration for SSH posture control, deploy a VM on Azure Local, enable Microsoft Defender for Cloud, and explore Azure Update Manager.

- No Azure CLI commands (challenge is primarily portal-based).
- No Azure Policy definitions inline.
- RBAC roles referenced as prerequisites: Reader, Azure Stack HCI VM Contributor (required for accessing shared ArcBox/LocalBox resources).

**Cross-reference:** The CHALLENGES_ANALYSIS rates Challenge 6 steps as primarily manual -- portal-based exploration, Defender for Cloud review, and Update Manager assessment are inherently interactive tasks that resist automation.

### walkthrough/challenge-06/solution-06.md

**Estimated duration:** 60-90 minutes.

This challenge is entirely portal-based with no Azure CLI commands in fenced code blocks. It guides participants through the Azure Portal UI to explore hybrid resources, configure policies, deploy VMs, and review security and update management tools.

**No Azure Policy definition JSON fragments** (references built-in policies by name only).

**No RBAC role assignment CLI commands.**

**Azure Policy assignments described (portal-based):**

1. "Configure SSH security posture for Linux (powered by OSConfig)" -- a built-in Machine Configuration policy. Scope: ArcBox resource group (e.g., rg-arcbox). Includes Arc connected servers. Audits SSH security baseline on Linux servers.

**RBAC roles referenced:**

1. Reader role on LocalBox/ArcBox resource groups (prerequisite, assigned by facilitator).
2. Azure Stack HCI VM Contributor on LocalBox resource group (prerequisite, assigned by facilitator).

**Tasks covered:**

| Task | Description | Automation Potential |
|---|---|---|
| Task 1 | Explore hybrid resources (ArcBox/LocalBox) in Azure Portal | Manual, portal-based |
| Task 2 | Azure Policy with Machine Configuration for SSH posture control | Partially automatable (policy assignment could use CLI) |
| Task 3 | Deploy VM on Azure Local via Portal | Manual, portal-based |
| Task 4 | Microsoft Defender for Cloud security monitoring | Manual, portal-based |
| Task 5 | Azure Update Manager for hybrid patching | Manual, portal-based |
| Task 6 | Wrap-up and discussion | Not applicable |

---

## Cross-Reference: Automation Feasibility Summary

Based on the INVENTORY CHALLENGES_ANALYSIS:

| Challenge | Key Steps | Automation Rating |
|---|---|---|
| Challenge 1 | Policy assignments, RBAC role creation, compliance review | Partial -- CLI commands fully automatable; compliance dashboard review is manual |
| Challenge 2 | Key Vault creation, key generation, storage CMK configuration | Fully Automatable -- all steps have CLI equivalents |
| Challenge 3 | Storage TLS enforcement, policy assignment, diagnostic settings, KQL queries | Fully Automatable -- all steps have CLI equivalents |
| Challenge 4 | VM deployment, Bastion, attestation client build and run | Partial -- infrastructure deployment automatable; Bastion SSH session and on-VM build steps require interactive access |
| Challenge 5 | AKS cluster, CVM node pool, attestation pod deployment | Fully Automatable -- all steps use CLI/kubectl commands |
| Challenge 6 | Portal exploration, Machine Configuration, VM deployment on Azure Local | Manual -- primarily portal-based; policy assignment could be automated |
