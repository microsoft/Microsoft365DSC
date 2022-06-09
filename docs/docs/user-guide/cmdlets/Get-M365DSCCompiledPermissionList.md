# Get-M365DSCCompiledPermissionList

## Description

This function lists all Graph permissions required for the specified resources,
both for reading and updating.

## Output

This function outputs information as the following type:
**System.Collections.Hashtable**

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| ResourceNameList | True | String[] |  |  | An array of resource names for which the permissions should be determined. |
| PermissionsType | False | String | Delegated | Delegated, Application |  |
| Source | False | String | Graph | Exchange, Graph |  |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Get-M365DSCCompiledPermissionList -ResourceNameList @('O365User', 'AADApplication') -Source 'Graph' -PermissionsType 'Delegated'`

-------------------------- EXAMPLE 2 --------------------------

`Get-M365DSCCompiledPermissionList -ResourceNameList @('O365User', 'AADApplication') -Source 'Graph' -PermissionsType 'Application'`

-------------------------- EXAMPLE 3 --------------------------

`Get-M365DSCCompiledPermissionList -ResourceNameList @('EXOAcceptedDomain') -Source 'Exchange'`


