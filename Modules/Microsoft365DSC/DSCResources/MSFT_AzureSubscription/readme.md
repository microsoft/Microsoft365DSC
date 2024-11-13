
# AzureSubscription

## Description

This resource controls the properties of an Azure subscription.

Users will need to grant permissions to the associated scope by running the following command in Azure Cloud Shell:
```Powershell
New-AzRoleAssignment -ObjectId "<Service Principal Object ID>" -Scope "Microsoft.Subscription/aliases/<subscription>" -RoleDefinitionName 'Contributor' -ObjectType 'ServicePrincipal'
```
