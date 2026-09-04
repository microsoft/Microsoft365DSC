# AzureRoleDefinition

## Description

This resource configures Azure RBAC custom role definitions. It only manages custom role definitions, not built-in roles.
The account used must have sufficient permissions to manage role definitions, such as `Owner` or `User Access Administrator` at the appropriate scope.

```powershell
New-AzRoleAssignment -ObjectId "<Service Principal Object ID>" -Scope "/" -RoleDefinitionName 'Owner' -ObjectType 'ServicePrincipal'
```
