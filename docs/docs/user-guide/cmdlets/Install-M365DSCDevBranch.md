# Install-M365DSCDevBranch

## Description

This function downloads and installs the Dev branch of Microsoft365DSC on the local machine

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| Scope | False | Object | AllUsers | CurrentUser, AllUsers | Specifies the scope of the update of the module. The default value is AllUsers(needs to run as elevated user). |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Install-M365DSCDevBranch`

-------------------------- EXAMPLE 2 --------------------------

`Install-M365DSCDevBranch -Scope CurrentUser`


