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

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Get-M365DSCCompiledPermissionList -ResourceNameList @('O365User', 'AADApplication')`



