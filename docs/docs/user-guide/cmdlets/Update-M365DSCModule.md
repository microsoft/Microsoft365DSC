# Update-M365DSCModule

## Description

This function updates the module, dependencies and uninstalls outdated dependencies.

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| Scope | False | Object | AllUsers | CurrentUser, AllUsers | Specifies the scope of the update of the module. The default value is AllUsers(needs to run as elevated user). |
| Proxy | False | String |  |  |  |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Update-M365DSCModule`

-------------------------- EXAMPLE 2 --------------------------

`Update-M365DSCModule -Scope CurrentUser`

-------------------------- EXAMPLE 3 --------------------------

`Update-M365DSCModule -Scope AllUsers`


