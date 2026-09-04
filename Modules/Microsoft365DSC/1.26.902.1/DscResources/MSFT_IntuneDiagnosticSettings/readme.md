# IntuneDiagnosticSettings

## Description

Configures Diagnostics settings in Intune.

Users will need to grant permissions to the associated scope by running the following command in Azure Cloud Shell:

```powershell
New-AzRoleAssignment -ObjectId "<Service Principal Object ID>" -Scope "/providers/Microsoft.intune" -RoleDefinitionName 'Contributor' -ObjectType 'ServicePrincipal'
```
