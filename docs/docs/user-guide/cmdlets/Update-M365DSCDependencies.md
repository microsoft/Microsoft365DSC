# Update-M365DSCDependencies

## Description

This function installs all missing M365DSC dependencies

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| Force | False | SwitchParameter |  |  | Specifies that all dependencies should be forcefully imported again. |
| ValidateOnly | False | SwitchParameter |  |  | Specifies that the function should only return the dependencies that are not installed. |
| Scope | False | Object | AllUsers | CurrentUser, AllUsers | Specifies the scope of the update of the module. The default value is AllUsers(needs to run as elevated user). |
| Proxy | False | String |  |  |  |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Update-M365DSCDependencies`

-------------------------- EXAMPLE 2 --------------------------

`Update-M365DSCDependencies -Force`

-------------------------- EXAMPLE 3 --------------------------

`Update-M365DSCDependencies -Scope CurrenUser`


