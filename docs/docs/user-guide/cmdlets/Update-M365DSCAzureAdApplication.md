# Update-M365DSCAzureAdApplication

## Description

This function creates or updates an application in Azure AD. It assigns permissions,
grants consent and creates a secret or uploads a certificate to the application.

This application can then be used for Application Authentication.

The provided permissions have to be as an array of hashtables, with Api=Graph, SharePoint
or Exchange and PermissionsName set to a list of permissions. See examples for more information.

NOTE:
If consent cannot be given for whatever reason, make sure all these permissions are
given Admin Consent by browsing to the App Registration in Azure AD > API Permissions
and clicking the "Grant admin consent for <orgname>" button.

More information:
Graph API permissions: https://docs.microsoft.com/en-us/graph/permissions-reference
Exchange permissions: https://docs.microsoft.com/en-us/exchange/permissions-exo/permissions-exo

Note:
If you want to configure App-Only permission for Exchange, as described here:
https://docs.microsoft.com/en-us/powershell/exchange/app-only-auth-powershell-v2?view=exchange-ps#step-2-assign-api-permissions-to-the-application
Using the following permission will achieve exactly that: @{Api='Exchange';PermissionName='Exchange.ManageAsApp'}

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| ApplicationName | False | String | Microsoft365DSC |  |  |
| Permissions | True True | Hashtable[] |  |  |  |
| Type | False | String | Secret | Secret, Certificate |  |
| MonthsValid | False | Int32 | 12 |  |  |
| CreateNewSecret | False | SwitchParameter |  |  |  |
| CertificatePath | False | String |  |  |  |
| CreateSelfSignedCertificate | False | SwitchParameter |  |  |  |
| AdminConsent | False | SwitchParameter |  |  |  |
| Message | True | String |  |  |  |
| Type | False | String | Info | Error, Warning, Info |  |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Update-M365DSCAzureAdApplication -ApplicationName 'Microsoft365DSC' -Permissions @(@{Api='SharePoint';PermissionName='Sites.FullControl.All'}) -AdminConsent -Type Secret`

-------------------------- EXAMPLE 2 --------------------------

`Update-M365DSCAzureAdApplication -ApplicationName 'Microsoft365DSC' -Permissions @(@{Api='Graph';PermissionName='Domain.Read.All'}) -AdminConsent -Type Certificate -CreateSelfSignedCertificate -CertificatePath c:\Temp\M365DSC.cer`

-------------------------- EXAMPLE 3 --------------------------

`Update-M365DSCAzureAdApplication -ApplicationName 'Microsoft365DSC' -Permissions @(@{Api='SharePoint';PermissionName='Sites.FullControl.All'},@{Api='Graph';PermissionName='Group.ReadWrite.All'},@{Api='Exchange';PermissionName='Exchange.ManageAsApp'}) -AdminConsent -Type Certificate -CertificatePath c:\Temp\M365DSC.cer`


