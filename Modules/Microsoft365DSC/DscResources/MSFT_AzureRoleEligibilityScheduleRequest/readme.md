# AzureRoleEligibilityScheduleRequest

## Description

This resource manages Azure PIM (Privileged Identity Management) role eligibility schedule requests for Azure RBAC roles. It supports role assignments and eligibility at all scope levels including subscription, management group, resource group, and resource-specific scopes.

## Key Differences from AADRoleEligibilityScheduleRequest

- **AADRoleEligibilityScheduleRequest**: Manages Entra ID (Azure AD) directory roles via Microsoft Graph API
- **AzureRoleEligibilityScheduleRequest**: Manages Azure RBAC roles via Azure Resource Manager API

## Supported Scope Levels

### Subscription Scope
Format: `/subscriptions/{subscriptionId}`

Example: Assign "Owner" eligibility on subscription

### Management Group Scope
Format: `/providers/Microsoft.Management/managementGroups/{managementGroupId}`

Example: Assign "Reader" eligibility on management group

### Resource Group Scope
Format: `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}`

Example: Assign "Contributor" eligibility on resource group

### Resource Scope
Format: `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}`

Example: Assign "Key Vault Administrator" eligibility on specific key vault

## Azure Government Cloud Support

This resource automatically detects the tenant region and uses the appropriate Azure Management endpoint:

- **Global Azure**: `https://management.azure.com`
- **Azure US Government**: `https://management.usgovcloudapi.net`
- **Azure US Government DoD**: `https://management.usgovcloudapi.net`

## Required Permissions

To manage Azure PIM role eligibility schedules, you need one of the following:

- **Privileged Role Administrator** role in Azure AD
- **Owner** or **User Access Administrator** role at the appropriate Azure scope
- Custom role with permissions:
  - `Microsoft.Authorization/roleEligibilityScheduleRequests/write`
  - `Microsoft.Authorization/roleEligibilitySchedules/read`
  - `Microsoft.Authorization/roleDefinitions/read`

## Known Limitations

- The resource creates new schedule requests rather than directly modifying existing schedules
- Schedule changes may take a few minutes to propagate
- Some built-in roles may have restrictions on eligibility assignments
- Management group scope requires appropriate permissions at the management group level

## Examples

See the Examples folder for comprehensive usage scenarios.
