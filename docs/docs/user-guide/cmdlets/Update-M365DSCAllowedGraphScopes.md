# Update-M365DSCAllowedGraphScopes

## Description

This function updates the required permissions for the specified resources and type
for the Microsoft Graph delegated application in Azure Active Directory.

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| ResourceNameList | False | String[] |  |  | An array of resource names for which the permissions should be determined. |
| All | False | SwitchParameter |  |  | Specifies that the permissions should be determined for all resources. |
| Type | True | String |  | Read, Update | For which action should the permissions be updated: Read or Update. |
| Environment | False | String | Global | Global, China, USGov, USGovDoD, Germany |  |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Update-M365DSCAllowedGraphScopes -ResourceNameList @('AADUSer', 'AADApplication') -Type 'Read'`

-------------------------- EXAMPLE 2 --------------------------

`Update-M365DSCAllowedGraphScopes -All -Type 'Update' -Environment 'Global'`


