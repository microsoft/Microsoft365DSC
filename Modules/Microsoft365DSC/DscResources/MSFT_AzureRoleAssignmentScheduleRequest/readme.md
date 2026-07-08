# AzureRoleAssignmentScheduleRequest

## Description

This resource manages Azure PIM (Privileged Identity Management) role assignment schedule requests for Azure RBAC roles. It supports role assignments at all scope levels including subscription, management group, resource group, and resource-specific scopes.

## Key Differences from AADRoleAssignmentScheduleRequest

- **AADRoleAssignmentScheduleRequest**: Manages Entra ID (Azure AD) directory roles via Microsoft Graph API
- **AzureRoleAssignmentScheduleRequest**: Manages Azure RBAC roles via Azure Resource Manager API

## Key Differences from AzureRoleEligibilityScheduleRequest

- **AzureRoleEligibilityScheduleRequest**: Manages role eligibility (makes principal eligible to activate the role via PIM)
- **AzureRoleAssignmentScheduleRequest**: Manages active role assignments (principal has the role actively assigned)

## Supported Scope Levels

### Subscription Scope
Format: `/subscriptions/{subscriptionId}`

Example: Assign "Owner" role on subscription

### Management Group Scope
Format: `/providers/Microsoft.Management/managementGroups/{managementGroupId}`

Example: Assign "Reader" role on management group

### Resource Group Scope
Format: `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}`

Example: Assign "Contributor" role on resource group

### Resource Scope
Format: `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}`

Example: Assign "Key Vault Administrator" role on specific key vault

## Azure Government Cloud Support

This resource automatically detects the tenant region and uses the appropriate Azure Management endpoint:

- **Global Azure**: `https://management.azure.com`
- **Azure US Government**: `https://management.usgovcloudapi.net`
- **Azure US Government DoD**: `https://management.usgovcloudapi.net`

## Required Permissions

To manage Azure PIM role assignment schedules, you need one of the following:

- **Privileged Role Administrator** role in Azure AD
- **Owner** or **User Access Administrator** role at the appropriate Azure scope
- Custom role with permissions:
  - `Microsoft.Authorization/roleAssignmentScheduleRequests/write`
  - `Microsoft.Authorization/roleAssignmentSchedules/read`
  - `Microsoft.Authorization/roleDefinitions/read`

## Known Limitations

- The resource creates new schedule requests rather than directly modifying existing schedules
- Schedule changes may take a few minutes to propagate
- Some built-in roles may have restrictions on assignments
- Management group scope requires appropriate permissions at the management group level

## Examples

See the Examples folder for comprehensive usage scenarios.
