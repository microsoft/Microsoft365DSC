# Get-M365DSCCompiledPermissionList

## Description

This function lists all Graph, SharePoint or Exchange permissions required for the specified
resources, both for reading/updating and Delegated/Applications. With the parameters, you can
specify a specific subset of permissions, to be use with the Permissions parameter of
Update-M365DSCAzureAdApplication.

## Output

This function outputs information as the following type:
**System.Collections.Hashtable**

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| ResourceNameList | True | String[] |  |  | An array of resource names for which the permissions should be determined. |
| PermissionType | False | String |  | Delegated, Application |  |
| AccessType | False | String |  | Read, Update | Specifies the workload of the permissions that need to get returned. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Get-M365DSCCompiledPermissionList -ResourceNameList @('EXOAcceptedDomain')`

-------------------------- EXAMPLE 2 --------------------------

`Get-M365DSCCompiledPermissionList -ResourceNameList (Get-M365DSCAllResources)`

-------------------------- EXAMPLE 3 --------------------------

`Get-M365DSCCompiledPermissionList -ResourceNameList (Get-M365DSCAllResources) -PermissionType 'Application' -AccessType 'Update'`

-------------------------- EXAMPLE 4 --------------------------

`Get-M365DSCCompiledPermissionList -ResourceNameList (Get-M365DSCAllResources) -PermissionType 'Delegated' -AccessType 'Read'`


